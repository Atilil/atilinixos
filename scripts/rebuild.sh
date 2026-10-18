#!/usr/bin/env bash
cd $NH_OS_FLAKE
git add .
alejandra --exclude $NH_OS_FLAKE/flake.nix $NH_OS_FLAKE
nix run $NH_OS_FLAKE#write-flake || { echo "write-flake a échoué"; exit 1; }
nh os switch 2>&1 | tee /tmp/nixos-build.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo ""
    echo "========================================"
    echo "  Build échoué — analyse en cours..."
    echo "========================================"
    echo ""
    cat /tmp/nixos-build.log | claude -p "Un build NixOS a échoué. En te basant sur le log ci-joint, identifie la cause principale de l'échec. Propose une solution concrète et directement applicable sous forme de correctif. Inclue le nom du fichier et le numéro de ligne affectés, ainsi qu'une brève explication du problème et de la correction."
fi
