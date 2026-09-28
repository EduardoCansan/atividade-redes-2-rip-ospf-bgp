#!/usr/bin/env bash
set -e

echo "=== Resumo BGP ==="
for r in r1 r2 r3 r4 r5; do
  echo
  echo "--- $r ---"
  docker exec "$r" vtysh -c "show ip bgp summary" || true
done

echo
echo "=== Tabela BGP do R5 ==="
docker exec r5 vtysh -c "show ip bgp" || true

echo
echo "=== Rotas BGP do R5 ==="
docker exec r5 vtysh -c "show ip route bgp" || true

echo
echo "=== Ping R5 -> 192.168.10.2 ==="
docker exec r5 ping -c 4 192.168.10.2 || true

echo
echo "=== Traceroute R5 -> 192.168.10.2 ==="
docker exec r5 traceroute 192.168.10.2 || true
