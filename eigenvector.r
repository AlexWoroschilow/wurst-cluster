options(expressions = 50000)
root=dirname(sys.frame(1)$ofile)
source('lib/igraph.r', chdir = TRUE)
source('lib/assert.r', chdir = TRUE)

arguments = commandArgs(trailingOnly = FALSE)

assert(!is.na((file_ncol = arguments[1])), "You have to define an input file, for example super_graph.ncol")
assert(!is.na((file_clust = arguments[2])), "You have to define an output file, for example super_graph.clust")


# file_ncol = "/home/sensey/Projects/wurst-cluster/var/t.ncol"
# file_clust = "/home/sensey/Projects/wurst-cluster/out/t.clust"

# file_ncol="/home/sensey/Projects/wurst-cluster/var/t_0.ncol"
# file_clust="/home/sensey/Projects/wurst-cluster/out/t_0.clust"

# file_ncol="/home/sensey/Projects/wurst-cluster/var/t2.ncol"
# file_clust="/home/sensey/Projects/wurst-cluster/out/t2.clust"
# 
# file_ncol="/home/sensey/Projects/wurst-cluster/var/t3.ncol"
# file_clust="/home/sensey/Projects/wurst-cluster/out/t3.clust"

# file_ncol="/home/sensey/Projects/wurst-cluster/var/wurstimibiss_aacid_1453825550.ncol"
# file_clust="/home/sensey/Projects/wurst-cluster/out/wurstimibiss_aacid_1453825550.clust"

# file_ncol="/home/sensey/Projects/wurst-cluster/var/wurstimibiss_salami_1453825697.ncol"
# file_clust="/home/sensey/Projects/wurst-cluster/out/wurstimibiss_salami_1453825697.clust"

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
