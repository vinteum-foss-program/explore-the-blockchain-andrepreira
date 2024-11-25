# Which tx in block 257,343 spends the coinbase output of block 256,128?
block_for_cb=256128
search_block=257343
cb_tx=$(bitcoin-cli getblockhash $block_for_cb | xargs bitcoin-cli getblock | jq -r '.tx[0]')
txs=$(bitcoin-cli getblockhash $search_block | xargs bitcoin-cli getblock | jq -r '.tx[]')
for tx in $txs; do
  spent=$(bitcoin-cli getrawtransaction $tx true | jq -r ".vin[] | select(.txid==\"$cb_tx\")")
  if [[ ! -z $spent ]]; then
    echo $tx
    break
  fi
done
