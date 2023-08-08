

def chatGPT_mysli(mysli, a=None, b=None):
    pass

def chatGPT_ocenia(mysli, min, max):
    pass

# def 

def wymysl_mi_abstrakcyjna_nazwe():
    nazwa = chatGPT_mysli("kurcze jaką bu tu wymyślić abstrakcyjna_funkcje") # call 1
    return nazwa

def wymysl_mi_jakas_prosta_abastrakcyjna_funkcja():
    nazwa_abstrakcyjna = wymysl_mi_abstrakcyjna_nazwe()
    return nazwa_abstrakcyjna

def stworz_funkcje():
    ile_tworzymy = 10
    funkcje = []
    for i in range(ile_tworzymy):
        funkcje.append(wymysl_mi_jakas_prosta_abastrakcyjna_funkcja())

    return funkcje

def przygotuj_dane():
    funkcje = stworz_funkcje()
    matrix_powiazan = [] 
    for funkcja_pierwsza in funkcje:
        wiersz_powiazan = []
        for funkcja_druga in funkcje:
            to_moze_byc_istotne = [funkcja_pierwsza, funkcja_druga]
            wiersz_powiazan.append(to_moze_byc_istotne)

        matrix_powiazan.append(wiersz_powiazan)

    return matrix_powiazan

def zastanow_sie_nad_i_ocen_powiazaniem_miedzy_nimi(a, b):
    pytania = [
        "Jak one moga byc ze soba powiazane powiazac?\n"
        "Co jeżeli są funkcjami i powinny być powiązane?"
    ]
    prompt = "\n".join(pytania)
    przmyslenia = chatGPT_mysli(prompt, a, b) # call 2

    pytania_na_temat_przmyslen = [
        "Czy to polaczenie mozna uznac za sensowne?"
        "jak oceniłbym sensownosć tego połączenia?"
    ]
    prompt = "\n".join(pytania_na_temat_przmyslen)
    ocena_werbalna = chatGPT_mysli("\n".join(pytania_na_temat_przmyslen), przmyslenia(a,b)) # call 3

    ocena_numeryczna = chatGPT_ocenia(ocena_werbalna(a,b), 1, 10) # call 4

    return ocena_numeryczna, przmyslenia, ocena_werbalna



def rozmyslania_powiazan(matrix_powiazan):
    taka_albo_lepsza = 7
    ciekawe_powiazania = []
    for wiersz_przemyslen in matrix_powiazan:
        for przemyslenie in wiersz_przemyslen:
            ocena_numeryczna, przmyslenia, ocena_werbalna = zastanow_sie_nad_i_ocen_powiazaniem_miedzy_nimi(przemyslenie[0], przemyslenie[1])
            if ocena_numeryczna > taka_albo_lepsza:
                ciekawe_powiazania
                przemyslenie.append(ocena_numeryczna)
                przemyslenie.append(przmyslenia)
                przemyslenie.append(ocena_werbalna)
    
            
przygotowane_dane = przygotuj_dane()
