#!/usr/bin/env bash
set -e

for r in r1 r2 r3 r4 r5; do
  echo "== Aplicando configuração em $r =="
  while IFS= read -r cmd; do
    [ -z "$cmd" ] && continue
    docker exec "$r" vtysh -c "$cmd" >/dev/null || true
  done < "configs/bgp/$r.conf"
done

echo "Configurações enviadas."
echo "Use ./scripts/verificar-bgp.sh para validar."
