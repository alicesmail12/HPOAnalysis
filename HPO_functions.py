def get_HPO_id(HPOTerm):
    term = pyhpo.Ontology.get_hpo_object(HPOTerm)
    return str(term)[:10] if term else None

def get_HPO_term(HPOID):
    HPOTerm = pyhpo.Ontology.get_hpo_object(HPOID)
    return str(HPOTerm)[13:] if HPOTerm else None

def get_all_parents(HPOID):
    term = pyhpo.Ontology.get_hpo_object(HPOID)
    parents = set()
    for parent in term.parents:
        parents.add(str(parent)[:10])
        parents |= get_all_parents(str(parent)[:10])
    return parents

def get_frequency(HPOTerms_col):
    return len(str(HPOTerms_col).split('|'))

def propagate_HPO_IDs(HPOIDs_col):
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
    HPOIDs = HPOIDs_col.str.split('|')
    HPOTerms = []
    for IDs in HPOIDs:
        terms = [get_HPO_term(ID) for ID in IDs]
        HPOTerms.append('|'.join(terms))
    return HPOTerms