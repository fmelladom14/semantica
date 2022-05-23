library(SPARQL)
endpoint <- "http://155.54.239.183:3041/blazegraph/namespace/Alzheimers"
#Query 1. How many reactions are recorded, and in which cell compartment.
query1 <-"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gr_ont: <http://www.semanticweb.org/paco/ontologies/2022/4/Alzheimers#>

SELECT ?localization (count(distinct ?reaction) as ?count)
WHERE{
?reaction gr_ont:hasLocation ?localization} GROUP BY ?localization
Order by ?count"
qd1 <- SPARQL(endpoint,query1)
View(as.data.frame(qd1$results))
#2. How many genes are located in each Chromosome.
query2 <-"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gr_ont: <http://www.semanticweb.org/paco/ontologies/2022/4/Alzheimers#>

SELECT ?Chromosome (count(distinct ?Gene) as ?count)
Where{
?Gene gr_ont:locatedIn ?Chromosome.
}
Group by ?Chromosome
HAVING (?count >1)
ORDER BY ?count"
qd2 <- SPARQL(endpoint,query2)
View(as.data.frame(qd2$results))
#3. Construct a graph of every gen that codifies a protein
query3 <-"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gr_ont: <http://www.semanticweb.org/paco/ontologies/2022/4/Alzheimers#>
CONSTRUCT { ?s gr_ont:encodedBy ?Gen}
WHERE
{
{ ?s rdf:type gr_ont:Protein } UNION { ?s gr_ont:encodedBy ?Gen }
}"
  qd3 <- SPARQL(endpoint,query3)
  View(as.data.frame(qd3$results))
  #4. Anything that has more than 30kd of molar mass, and the ordered result.
  query4 <-"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gr_ont: <http://www.semanticweb.org/paco/ontologies/2022/4/Alzheimers#>

SELECT ?s ?mass
WHERE {
?s gr_ont:molecularWeight  ?mass .
FILTER (?mass >= 30)
}
ORDER BY ?mass"
qd4 <- SPARQL(endpoint,query4)

#5. Every cytokine involved, it's uniprot ID and comments if available.
query5 <-"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gr_ont: <http://www.semanticweb.org/paco/ontologies/2022/4/Alzheimers#>
PREFIX uni: <https://www.uniprot.org/uniprot>
SELECT ?cytokine  ?UniProt ?Definicion
WHERE {
?cytokine rdfs:subClassOf gr_ont:cytokine .
?cytokine uni: ?UniProt .
?cytokine rdfs:comment ?Definicion
}"
qd5 <- SPARQL(endpoint,query5)
View(as.data.frame(qd5$results))
#6. Is reaction17 mediated by Toll like Receptors??
query6 <-"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX gr_ont: <http://www.semanticweb.org/paco/ontologies/2022/4/Alzheimers#>
ASK
WHERE { gr_ont:reaction17 gr_ont:mediatedBy gr_ont:TLR}"
qd6 <- SPARQL(endpoint,query6)
View(as.data.frame(qd6$results))