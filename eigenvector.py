#! /usr/bin/python2

import igraph

from igraph import GraphBase
from igraph import VertexClustering



# class Graph(igraph.Graph):
#     def community_leading_eigenvector(self, clusters=None, weights=None,  arpack_options=None):
#         if clusters is None:
#             clusters = -1
#
#         kwds = dict(weights=weights)
#         if arpack_options is not None:
#             kwds["arpack_options"] = arpack_options
#
#         membership, _, q = GraphBase.community_leading_eigenvector(self, clusters, **kwds)
#         return VertexClustering(self, membership, modularity = q)
#         pass


class ClusterLeadingEigenvector(object):
    def __init__(self, path):
        self._index=0
        self._graph = igraph.read(path, format="ncol", directed=False, names=True)
        self._graph.delete_edges(self._graph.es.select(weight_lt=0.5))
        self._graph.simplify(combine_edges=max)

    @property
    def options(self):
        options = igraph.ARPACKOptions()
        options.maxiter = 2147483647
        options.tol = 0.0000001
        return options

    @property
    def index(self):
        self._index += 1
        yield self._index

    @property
    def cluster(self):
        for subgraph in self._graph.decompose(minelements=0):
            communities = subgraph.community_leading_eigenvector(weights="weight", arpack_options=self.options)
            for index, community in zip(self.index, communities.subgraphs()):
                for local, name in enumerate(community.vs["name"], start=1):
                    yield [index, local, name]





graph = ClusterLeadingEigenvector("var/t2.ncol")
# graph = ClusterLeadingEigenvector("var/wurstimibiss_aacid_1453825550.ncol")
# graph = ClusterLeadingEigenvector("var/wurstimibiss_salami_1453825697.ncol")
for cluster, index, name in graph.cluster:
    print "%d\t%d\t%s" % (cluster, index, name)
    pass
