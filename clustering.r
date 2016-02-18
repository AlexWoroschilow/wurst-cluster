#!/bin/env Rscript

arguments = commandArgs(trailingOnly = TRUE)
source('lib/igraph.r', chdir = TRUE)
source('lib/assert.r', chdir = TRUE)


assert(!is.na((file_source = arguments[1])), "You have to define an input file, for example super_graph.ncol")
assert(!is.na((file_result = arguments[2])), "You have to define an output file, for example super_graph.clust")


filter_weight = 0.5

#tryCatch((G = read.graph(file_ncol, format = 'ncol')), error = function(w)
#  stop("Exception: can not read graph file!")
#)
cat(paste("read graph file:", file_source, "\n"))
G = read.graph(file_source, format = 'ncol')

G = delete.edges(G, which(E(G)$weight < filter_weight))
G = delete.edges(G, which(is.na(E(G)$weight)))

G = as.undirected(G, "each")
G = as.undirected(G, "collapse")

tryCatch({
  clsuter = cluster.leading.eigenvector.community(G)
  write(paste(clsuter$cluster, "\t", clsuter$index, "\t", clsuter$name), file = file_result)
}, error = function(w) {
  stop(paste("Exception: can not read graph file", plot(subgraph)))
})
