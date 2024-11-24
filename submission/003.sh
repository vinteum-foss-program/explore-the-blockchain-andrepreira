# How many new outputs were created by block 123,456?

hash=$(bitcoin-cli getblockhash 123456)
txs=$(bitcoin-cli getblock $hash | jq -r '.tx[]')
count=0
for tx in $txs; do
  outputs=$(bitcoin-cli getrawtransaction $tx true | jq '.vout | length')
  count=$((count + outputs))
done

echo $count