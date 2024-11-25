# Only one single output remains unspent from block 123,321. What address was it sent to?
block=123321
blockhash=$(bitcoin-cli getblockhash $block)
txs=$(bitcoin-cli getblock $blockhash | jq -r '.tx[]')
unspent_utxos=0

for tx in $txs; do
    if [[ ${#tx} -eq 64 ]]; then
        raw_tx=$(bitcoin-cli getrawtransaction $tx true)
        for i in $(seq 0 $(($(echo $raw_tx | jq '.vout | length')-1))); do
            utxo=$(bitcoin-cli gettxout $tx $i)
            if [[ ! -z "$utxo" ]]; then
                address=$( echo "$utxo" | jq -r '.scriptPubKey.address')
                echo $address
                break
            fi
        done
    else
        echo "Transaction $tx does not have valid txid"
    fi
done
