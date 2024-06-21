def get_HPO_id(HPOTerm):
    '''
    Gets HPO ID from an HPO term
    '''
    term = Ontology.get_hpo_object(HPOTerm)
    return str(term)[:10] if term else None


def get_HPO_term(HPOID):
    '''
    Gets HPO term from an HPO ID
    '''
    HPOTerm = Ontology.get_hpo_object(HPOID)
    return str(HPOTerm)[13:] if HPOTerm else None


def get_all_parents(HPOID):
    '''
    Iteratively gets all parent terms from an HPO ID
    '''
    term = Ontology.get_hpo_object(HPOID)
    parents = set()
    for parent in term.parents:
        parents.add(str(parent)[:10])
        parents |= get_all_parents(str(parent)[:10])
    return parents


def get_frequency(HPOTerms_col):
    '''
    Gets number of terms from a string separated by '|'
    '''
    return len(str(HPOTerms_col).split('|'))


def propagate_HPO_IDs(HPOIDs_col):
    '''
    Gets all parent terms of a list of HPO IDs, only adding terms if they are not already present
    '''
    HPOIDs = HPOIDs_col.tolist()
    HPOIDs_longlist = []
    for HPOID_list in HPOIDs:
        HPOIDs_longlist.append(str(HPOID_list).split('|'))
    for HPOIDs_list in HPOIDs_longlist:
        propagated_HPOIDs = set()
        for phenotype in HPOIDs_list:
            parents = get_all_parents(phenotype)
            propagated_HPOIDs |= parents 
            for phenotype in list(propagated_HPOIDs):
                if str(phenotype) not in HPOIDs_list:
                    HPOIDs_list.append(phenotype)
    return HPOIDs_longlist


def get_HPO_terms(HPOIDs_col):
    '''
    Converts string of HPO IDs to string of HPO terms
    '''
    HPOIDs = HPOIDs_col.str.split('|')
    HPOTerms = []
    for IDs in HPOIDs:
        terms = [get_HPO_term(ID) for ID in IDs]
        HPOTerms.append('|'.join(terms))
    return HPOTerms


def get_child_terms(term, IDChildrenList, termChildrenList):
    '''
    Gets all child terms of a term
    '''
    for HPO in Ontology.get_hpo_object(term).children:
        IDChildrenList.append(str(HPO)[0:10])
        for HPO2 in HPO.children:
            IDChildrenList.append(str(HPO2)[0:10])
            for HPO3 in HPO2.children:
                IDChildrenList.append(str(HPO3)[0:10])
                for HPO4 in HPO3.children:
                    IDChildrenList.append(str(HPO4)[0:10])
                    for HPO5 in HPO4.children:
                        IDChildrenList.append(str(HPO5)[0:10])
    for HPO in IDChildrenList:
        termChildrenList.append(get_HPO_term(HPO))