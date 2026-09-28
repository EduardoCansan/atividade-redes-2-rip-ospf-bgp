# Topologia BGP

## Sistemas Autônomos

```text
              AS200
        +------------------+
        |   R2 -- R3       |
AS100   |    \   /        |   AS300
 R1 ----+     R4           +---- R5
        +------------------+
```

Distribuição utilizada:

- R1: AS100
- R2, R3 e R4: AS200
- R5: AS300

Redes do núcleo observadas no experimento:

- R1 ↔ R2: `10.0.12.0/29`
- R1 ↔ R4: `10.0.14.0/29`
- R2 ↔ R3: `10.0.23.0/29`
- R2 ↔ R4: `10.0.24.0/29`
- R3 ↔ R5: `10.0.35.0/29`
- R4 ↔ R5: `10.0.45.0/29`

Redes finais:

- AS100: `192.168.10.0/24`
- AS300: `192.168.50.0/24`

A validação final foi feita do R5 para `192.168.10.2`.
