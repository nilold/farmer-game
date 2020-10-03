# farmer-game
This game is inspired by Maxis's SimFarm (1993). However, it has the ambition of being more realistic both in agronomic and in a financial way. That means that I am trying to create a model for a crop that responds to the environment (soil, weather, diseases, fertilizers, pesticides, hydric stress, etc) and also a model for the economic system where you have to buy and sell in a very competitive market. For the first version, I will focus on coffee crops. I had to do this because, in the level of realism that I am trying to achieve for the crop models, two different cultivars have very different logic behaviors. However, I'm trying to structure it in such a way that it can be easily extensible for other crop models. 

It's the first time I´m using the Godot engine, and it's the first time I´m making a game from scratch at all. So I am pretty sure that it will have a lot of issues in logic and performance at first, which I will try to address while developing the game core.

Godot is a wonderful open-source game engine, written in C++ and in GodotScript, which allows you to create games using a GUI and codes in GodotScript (python-like) or C#. It is also possible to write code in C++ and integrate it with Godot. I don't know how to do it yet, but it is something that I surely will do to solve some performance and code cleanness issues: Instantiating many crops at the same time is currently taking to long; Godot Script has a week OOP structure, and I'm missing Interfaces and Abstract Classes very much, which I believe will be a problem when I try to add other cultivars beside coffee.

### TODO: translate
### TODO: compelte
 ## Coffee
 ### Crop model
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
