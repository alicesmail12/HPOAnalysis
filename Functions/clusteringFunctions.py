def get_HPO_list(row):
    '''
    Creates HPO list from a row
    '''
    hpo_list = row._list
    hpo_id_list = [hpo.id for hpo in hpo_list]
    return hpo_id_list


def filter_highest_ic_terms(hpo_set, max_number_of_terms, kind = 'omim', list_or_object = 'list'):
    '''
    Filters set of HPO terms, prioritising by IC
    '''
    df = pd.DataFrame([hpo.id for hpo in hpo_set._list], columns=['terms'])
    df['ic'] = [hpo.information_content[f'{kind}'] for hpo in hpo_set._list]
    df = df.sort_values(by='ic', ascending=False)
    fdf = df.nlargest(max_number_of_terms, 'ic')
    if list_or_object == 'list':
        return fdf['terms'].tolist()

    
def get_HPOID_cluster_freq(decipher_cluster_df, all_HPOTerms):
    '''
    Get frequency of each HPO term in each cluster
    '''
    clusterHPO = decipher_cluster_df["propagatedTerms"].tolist()
    clusterHPO_lists = []
    for list_phenotypes in clusterHPO:
        list_phenotypes = list_phenotypes.split('|')
        clusterHPO_lists.append(list_phenotypes)
    clusterHPO_flat_list = [item for sublist in clusterHPO_lists for item in sublist]
    clusterHPO_freq_count = Counter(clusterHPO_flat_list)
    clusterHPO_ID_freq = {}
    for term in all_HPOTerms:
        if term in clusterHPO_freq_count:
            clusterHPO_ID_freq[term] = clusterHPO_freq_count[term]
        else:
            clusterHPO_ID_freq[term] = 0
    return clusterHPO_ID_freq

def get_sigincreased_HPOTerms_cluster(cluster_num, clusters_freq, cluster_freqs, total_clusters):
    '''
    Get significantly increased terms in each cluster
    '''
    cluster_index = cluster_num-1
    for index, row in clusters_freq.iterrows():
            cluster_freq = row["cluster_"+str(cluster_num)+"_freq"]
            outside_cluster_freq = (row[1:total_clusters+1].sum(axis=0) - cluster_freq)
            contingency_arrays = np.array([[cluster_freq, outside_cluster_freq], [(cluster_freqs[cluster_index])-cluster_freq, (sum(cluster_freqs)-cluster_freqs[cluster_index])-outside_cluster_freq]])
            contingency_table = np.asmatrix(contingency_arrays)
            odd_ratio, p_value = fisher_exact(contingency_table)
            clusters_freq.loc[index, "cluster_"+str(cluster_num)+"_p_value"] = p_value
            clusters_freq.loc[index, "cluster_"+str(cluster_num)+"_OR"] = odd_ratio

    # Create list of p-values
    p_values = list(clusters_freq["cluster_"+str(cluster_num)+"_p_value"])
    p_adj = multi.fdrcorrection(p_values, alpha=0.05, method='indep', is_sorted=False)

    # Assign adjusted p-values to new column
    clusters_freq["cluster_"+str(cluster_num)+"_adj_p_value"] = p_adj[1]
    clusters_freq['cluster_'+str(cluster_num)+'_significant'] = np.where((clusters_freq['cluster_'+str(cluster_num)+'_adj_p_value']<0.05) & (clusters_freq['cluster_'+str(cluster_num)+'_OR']>1), "Y", "N")
    clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'] = ' '
    clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'] = np.where((clusters_freq['cluster_'+str(cluster_num)+'_adj_p_value']<0.05) & (clusters_freq['cluster_'+str(cluster_num)+'_OR']>1), "*", clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'])
    clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'] = np.where((clusters_freq['cluster_'+str(cluster_num)+'_adj_p_value']<0.01) & (clusters_freq['cluster_'+str(cluster_num)+'_OR']>1), "**", clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'])
    clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'] = np.where((clusters_freq['cluster_'+str(cluster_num)+'_adj_p_value']<0.005) & (clusters_freq['cluster_'+str(cluster_num)+'_OR']>1), "***", clusters_freq['cluster_'+str(cluster_num)+'_sig_indicate'])
    clusters_freq_significant = clusters_freq[(clusters_freq['cluster_'+str(cluster_num)+'_significant']=="Y")]
    clusters_freq_significant = clusters_freq_significant[(clusters_freq_significant['cluster_'+str(cluster_num)+'_OR']>1)]
    return clusters_freq