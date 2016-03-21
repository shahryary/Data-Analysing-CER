toRun = quote( .(MeankWh = mean(kWh)))
test_ <- mainData[, 
                  eval(toRun),
                  by=.(ID)] # mean per  ID 


#-------------------
# Calinsky criterion:  approach to diagnosing how many clusters suit the data.

fit <- cascadeKM(scale(test_, center = TRUE,  scale = TRUE), 1, 10, iter = 1000)
plot(fit, sortg = TRUE, grpmts.plot = TRUE)
calinski.best <- as.numeric(which.max(fit$results[2,]))
cat("Calinski criterion optimal number of clusters:", calinski.best, "\n")

#-------------------
#Determine the optimal model and number of clusters according to the Bayesian Information Criterion 
#for expectation-maximization, initialized by hierarchical clustering for parameterized Gaussian 
#mixture models
# Run the function to see how many clusters
# it finds to be optimal, set it to search for
# at least 1 model and up 20.
d_clust <- Mclust(as.matrix(test_), G=1:20)
m.best <- dim(d_clust$z)[1]
cat("model-based optimal number of clusters:", m.best, "\n")
plot(d_clust)

#-------------------------- need to time to proccess and see results
# Affinity propagation (AP) clustering, see http://dx.doi.org/10.1126/science.1136800
d.apclus <- apcluster(negDistMat(r=2), test_)
cat("affinity propogation optimal number of clusters:", length(d.apclus@clusters), "\n")
heatmap(d.apclus)
plot(d.apclus, test_)


