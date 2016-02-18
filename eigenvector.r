options(expressions = 50000)
root=dirname(sys.frame(1)$ofile)
source(paste(root,'/lib/igraph.r', sep=""))
source(paste(root,'/lib/assert.r', sep=""))

arguments = commandArgs(trailingOnly = TRUE)

assert(!is.na((file_ncol = arguments[1])), "You have to define an input file, for example super_graph.ncol")
assert(!is.na((file_clust = arguments[2])), "You have to define an output file, for example super_graph.clust")


# file_source = "/home/sensey/Projects/GraphToCluster/var/t.ncol"
# file_source="/home/sensey/Projects/GraphToCluster/var/t_0.ncol"
# file_source="/home/sensey/Projects/GraphToCluster/var/t2.ncol"
# file_source="/home/sensey/Projects/GraphToCluster/var/t3.ncol"
# file_source="/home/sensey/Projects/GraphToCluster/var/wurstimibiss_aacid_1453825550.ncol"
# file_source="/home/sensey/Projects/GraphToCluster/var/wurstimibiss_salami_1453825697.ncol"
filter_weight = 0.5

tryCatch((G = read.graph(file_ncol, format = 'ncol')), error = function(w)
  stop("Exception: can not read graph file!")
)

G = delete.edges(G, which(E(G)$weight < filter_weight))
G = delete.edges(G, which(is.na(E(G)$weight)))

G = as.undirected(G, "each")
G = as.undirected(G, "collapse")

tryCatch({
  clsuter = cluster.leading.eigenvector.community(G)
  write(paste(clsuter$cluster, "\t", clsuter$index, "\t", clsuter$name), file = file_clust)
}, error = function(w) {
  stop(paste("Exception: can not read graph file", plot(subgraph)))
})
