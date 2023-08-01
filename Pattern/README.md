# Summarized Templates in SmartCoCo

The following shows the templates (patterns) and keywords summarized in SmartCoCo. They are summarized in one-time effort, developers can add custom patterns by following these patterns. The following patterns are case-insensitive.

To simplify the description, we use <> to record the words with POS tags to be extracted in the sentences, as we present in the paper. Besides, the meaning of other symbol are the same as the regular expression. 

The keywords contains two parts, i.e. used for text matching and specific checking.

To, see the source of these pattern, we also provide [a list of our analyzed contracts](https://github.com/SCCoCo/SmartCoCo/blob/main/Pattern/Analyzed%20contracts.md).

## Constraint Templates 

The basic 20 patterns are as follows. SmartCoCo first matches the keyword patterns, and then uses POS tags to extract entities. Finally, it leverages the special words to include or exclude some entities.  

#### Role permission 
| Pattern Keywords | Pattern                                                      |
| ------------------------- | --------------------------------------------------------- |
| ONLY     &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp;  | ONLY \<DT>? \<JJ, VBN>? \<NN> CAN?   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;          |
| ONLY        | Only AVAILABLE TO THE \<JJ, VBN>? \<NN>. |
| ONLY CALLED | ONLY CALLE?D? BY  \<DT>? \<JJ, VBN>? \<NN>.          |
| ALLOWS   | ALLOWS? \<DT>? \<JJ, VBN>? \<NN> \<TO>? ...         |
| ACCESS TO   | ALLOWS? \<DT>? \<JJ, VBN>? \<NN> ACCESS TO ...       |
| ROLE        | ...\(HAVE\|HAS\|WITH) \<DT>? \<JJ, VBN>? \<NN> ROLE. |





#### Parameter scope

Since we can directly consider the parameters, we introduce a new symbol PA to present the function parameters. The last AND pattern is used for all the subjects and objects in the above patterns.

| Pattern Keywords      | Pattern                                             |
| ------------------------- | --------------------------------------------------------- |
| AT MOST               | \<PA, NN> \<V>? AT LEAST <NN, IN, CD, RB, VBN>               |
| NOT BE                | \<PA, NN> CAN ?NOT BE <NN, IN, CD, RB, VBN>                  |
| GREATER, HIGHER       | \<PA, NN> CAN ?NOT BE (GREATER\|HIGHER) THAN <NN, IN, CD, RB, VBN>     |
| GREATER, HIGHER, MORE | \<PA, NN> \<V>? NO (GREATER\|MORE\|HIGHER) THAN <NN, IN, CD, RB, VBN> |
| GREATER, HIGHER, MORE | \<PA, NN> \<V>? (GREATER\|MORE\|HIGHER) THAN <NN, IN, CD, RB, VBN> |
| LESS                  | \<PA, NN> \<V>? LESS THAN <NN, IN, CD, RB, VBN>              |
| LESS                  | \<PA, NN> \<V>? NOT? LESS THAN <NN, IN, CD, RB, VBN>         |
| AT LEAST              | \<PA, NN> \<V>? AT LEAST <NN, IN, CD, RB, VBN>               |
| THE SAME              | \<PA, NN> \<AND>? \<PA, NN> HAVE THE SAME <NN, IN, CD, RB, VBN> |
| EQUAL                 | \<PA, NN>  (MUST\|SHOULD) (EQUAL TO\|EQUAL) <NN, IN, CD, RB, VBN> |
| AND                   | <PA, NN, IN, CD, RB, VBN> AND <PA, NN, ...>                  |



#### Event Emission

We extract all the words which keep the following structures.

| Pattern Keywords | Pattern                                                      |
| ------------------------- | --------------------------------------------------------- |
| EMITS EVENT   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  | EMITS? \<DT>? ([\w\(\)\{\}]+) EVENTS?     &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;                    |
| EMITS AND EVENT | EMITS? \<DT>? ([\w\(\)\{\}]+) \<AND> ([\w\(\)\{\}]+) EVENTS? |





#### Comment Inheritance

Since the POS of contract names are various and sentence structures are more determined,  we do not care the POS. We just use the contract name instead.

| Pattern Keywords | Pattern                             |
| ------------------------- | --------------------------------------------------------- |
| See    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp;    | See {\<Contract:Ct>-\<Function:Fn>}   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; |
| Inheritdoc | @Inheritdoc (\<Contract:Ct>)      |



### Specific Keywords

The following words have a special judge on their POS tags or the sentence. For different types, the strategy may have some difference.

Treat as NN: from, to

Special judge: token owner, spender, anyone, everyone, potential, someone, anybody, reset, transfer, buyer, customer, consumer, lp, liquidator, int, market, withdrawal, pool, community, asset, player, purchase, seller, contributions, user, contract, clients, slot, liquidity, token, app, beneficia, fee, crowdsale, call, when, but, whether, after, before, whether, module, allowance, frontend, operation, way, payment, eth, collateral, erc, btc, dai, function, array, account, one, nft, sign, sender, party, parti, investor, buyer, anonymous, transaction, fund, person, taker, people, address, wallet, holder, functionality, recipient, other, control, log, event, a, an, the, this, in, on, as, at, char, gas, v, r, s

