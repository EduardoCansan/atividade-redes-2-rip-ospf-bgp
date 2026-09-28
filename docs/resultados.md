# Resultados observados

## RIP

- Rotas aprendidas identificadas por `R`.
- Métrica relacionada ao número de saltos.
- Validação por tabela de roteamento, ping e traceroute.

## OSPF

- Formação de adjacências verificada.
- Rotas aprendidas identificadas por `O`.
- Escolha baseada no custo acumulado.
- O custo de uma interface do caminho foi alterado para `100` e o caminho foi novamente analisado.

## BGP

No R5/AS300 foi observada a rota:

```text
192.168.10.0/24 -> next-hop 10.0.35.2
AS_PATH: 200 100
```

Também foi observada sua instalação na tabela de roteamento com código `B`.

Durante o diagnóstico houve um estágio em que o R5 possuía a rota de ida, mas o ping ainda apresentava perda total. Foram verificadas e anunciadas redes intermediárias necessárias ao retorno.

Resultado final:

```text
4 packets transmitted
4 packets received
0% packet loss
```

O traceroute final confirmou que os pacotes saíam do AS300, atravessavam roteadores do AS200 e alcançavam a rede `192.168.10.0/24` do AS100.
