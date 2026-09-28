# Atividade 05 — RIP, OSPF e BGP

Repositório da atividade prática da disciplina **Redes de Computadores**.

O objetivo é registrar as configurações utilizadas nos testes de **RIPv2, OSPF e BGP**, além de explicar como reproduzir e validar os experimentos.

## Ambientes utilizados

- **RIP e OSPF:** Cisco Packet Tracer
- **BGP:** Ubuntu + Docker + FRRouting (FRR)
- Ferramentas de validação: tabelas de roteamento, vizinhanças/sessões, `ping` e `traceroute`

## Estrutura

```text
atividade-05-rip-ospf-bgp/
├── README.md
├── configs/
│   ├── rip/
│   │   └── comandos-rip.txt
│   ├── ospf/
│   │   └── comandos-ospf.txt
│   └── bgp/
│       ├── r1.conf
│       ├── r2.conf
│       ├── r3.conf
│       ├── r4.conf
│       └── r5.conf
├── scripts/
│   ├── aplicar-bgp.sh
│   └── verificar-bgp.sh
└── docs/
    ├── topologia-bgp.md
    └── resultados.md
```

## 1. RIP

O RIPv2 foi configurado no Packet Tracer anunciando as redes diretamente conectadas de cada roteador.

O arquivo [`configs/rip/comandos-rip.txt`](configs/rip/comandos-rip.txt) contém a sequência de comandos utilizada como referência.

Validação:

```text
show ip route rip
show ip protocols
show ip route
ping <destino>
tracert <destino>
```

As rotas aprendidas via RIP aparecem com o código `R`. A métrica utilizada pelo RIP corresponde ao número de saltos.

## 2. OSPF

Depois dos testes com RIP, a configuração RIP foi removida e a mesma topologia foi utilizada para OSPF.

O arquivo [`configs/ospf/comandos-ospf.txt`](configs/ospf/comandos-ospf.txt) contém os comandos de configuração e de alteração do custo.

Validação:

```text
show ip route ospf
show ip protocols
show ip ospf neighbor
show ip ospf interface
ping <destino>
tracert <destino>
```

Também foi alterado o custo de uma interface:

```text
configure terminal
interface <interface>
ip ospf cost 100
```

Depois da alteração, a tabela de roteamento e o `traceroute` foram executados novamente para observar o recálculo da rota.

## 3. BGP

O teste BGP foi realizado em containers Docker executando FRRouting.

### Sistemas Autônomos

| Roteador | AS |
|---|---:|
| R1 | 100 |
| R2 | 200 |
| R3 | 200 |
| R4 | 200 |
| R5 | 300 |

As redes utilizadas no núcleo do experimento incluem:

```text
10.0.12.0/29
10.0.14.0/29
10.0.23.0/29
10.0.24.0/29
10.0.35.0/29
10.0.45.0/29
```

Redes finais observadas:

```text
AS100: 192.168.10.0/24
AS300: 192.168.50.0/24
```

Os arquivos `configs/bgp/r1.conf` até `r5.conf` documentam as configurações BGP utilizadas no experimento.

### Aplicar as configurações

Com os containers `r1`, `r2`, `r3`, `r4` e `r5` em execução:

```bash
chmod +x scripts/aplicar-bgp.sh
./scripts/aplicar-bgp.sh
```

O script envia os comandos para o `vtysh` de cada container.

### Verificar o BGP

```bash
chmod +x scripts/verificar-bgp.sh
./scripts/verificar-bgp.sh
```

Ou manualmente:

```bash
docker exec r5 vtysh -c "show ip bgp summary"
docker exec r5 vtysh -c "show ip bgp"
docker exec r5 vtysh -c "show ip route bgp"
docker exec r5 ping -c 4 192.168.10.2
docker exec r5 traceroute 192.168.10.2
```

## Resultado final observado

No R5 (AS300), a rede `192.168.10.0/24` foi aprendida via BGP.

Um dos resultados finais observados foi:

```text
Network          Next Hop       Path
192.168.10.0/24  10.0.35.2      200 100 i
```

O `AS_PATH 200 100` indica que o anúncio recebido pelo AS300 passou pelo **AS200** e teve origem no **AS100**.

A rota também foi instalada na tabela de roteamento do R5 com código `B`.

Após os ajustes das rotas anunciadas, o teste fim a fim apresentou:

```text
4 packets transmitted
4 packets received
0% packet loss
```

O `traceroute` foi utilizado para confirmar os saltos IP efetivamente percorridos.

> Observação: `AS_PATH` e `traceroute` representam informações diferentes. O primeiro registra Sistemas Autônomos presentes no anúncio BGP; o segundo mostra os saltos IP usados no encaminhamento dos pacotes.

## Problema encontrado durante o BGP

Durante a configuração, o R5 inicialmente conhecia a rota para `192.168.10.0/24`, mas o `ping` apresentava 100% de perda.

A investigação das tabelas mostrou que também era necessário garantir as rotas de retorno entre as redes intermediárias. Redes do núcleo, como `10.0.23.0/29` e `10.0.35.0/29`, foram anunciadas durante os ajustes.

Após a correção, a comunicação fim a fim passou a funcionar com 0% de perda.

## Observação sobre FRRouting

Durante os testes apareceu a mensagem:

```text
Can't open configuration file /etc/frr/vtysh.conf due to 'No such file or directory'
```

Ela não impediu a execução dos comandos utilizados no experimento. As configurações foram aplicadas diretamente pelo `vtysh`.

Também foi utilizada uma `route-map` permissiva nas sessões eBGP:

```text
route-map PERMIT-ALL permit 10
```

## Autoria

Material produzido para a Atividade 05 de Redes de Computadores.
