# farmer-game
 godot project of a farming simulator game

 ## Cafeeiro
 ### Modelo da planta

- Nutrição
    - Componentes:
        - Água
        - Minerais
        - Matéria orgânica
    - Mecânica: A cada ciclo é extraída uma quantidade determinada pelo *fluxo de absorção* até que se alcance a *quantidade de saturação*. A saúde da planta em cada cíclo é determinada, entre outras coisas, pela qunatidade presente na planta.
        - Fluxo de absorção
        - Quantidade desejada
        - QUantidade de saturação   
    - A entidade Substract é um container de nutrientes.

- Saúde
    - Mecânica: a cada ciclo, a saúde é calculada/alterada com base em fatores da planta.
    - Afeta diretamente: Sistema imunológico, estado vital da planta (viva/morta)
    - Nutrição (Água, minerais, matéria orgânica)
        - Afetada por: baixa concentração no solo
        - Afeta: Capacidade de desenvolvimento
    - *Índice de desfolha*: percentual de folhas perdidas
        - Afetada por: doenças
        - Afeta: *Capacidade energética* (fotosíntese)
            - Afeta: Capacidade de desenvolvimento

- Desenvolvimento:
    - Afetado por:
        - Nutrição
        - Capacidade energética
    - Fases:
        - Desenvolvimento de ramos (crescimento)
        - Redução da desfolha (recuperação)
        - Desenvolvimento de frutos (produção)
    - Mecânica: A cada ciclo, a planta dedica um certo percentual para cada fase, totalizando 100%. O que influencia nessa distribuição? **TODO: Pesquisar**


 - Problemas
    - Ferrugem / Cercosporiose
        - Afeta: desfolha
        - Estágio ação: **TODO: pesquisar**
        - Ciclo de vida: **TODO: pesquisar**
    - Bicho Mineiro
        - Afeta: desfolha
        - Estágio ação: **TODO: pesquisar**
        - Ciclo de vida: **TODO: pesquisar**
    - Nematóide
        - Afeta: **TODO: pesquisar**
        - Estágio ação: **TODO: pesquisar**
        - Ciclo de vida: **TODO: pesquisar**
    - Broca
        - Afeta: produtividade
        - Estágio ação: enquanto há frutos
        ]- Ciclo de vida: fica viva, porém inativa em *frutos velhos remanecentes* **(TODO: novo parâmetro do modelo? Esse parâmetro pode ser usado para determinar a probabilidade de infeção pela broca)** após a colheita. Migram para frutos novos durante o estágio produtivo.
- Sistema imunolõgico
    - Mecânica: a cada ciclo, reduz a saúde de agentes presentes.
    - Natural
    - Defensivos
- Clima:
    - Temperatura
    - Humidade / Chuvas
- Geográfico
    - Relevo?
    - Altitude
