Question 1
select count(u_id) from users;-- this will count all the users in the users table based on their id

Question 2
select count(transfer_id) from transfers where send_amount_currency='CFA';
-- this statement will display all transactions made in CFA currency
Question 3
select count(DISTINCT u_id) from transfers where send_amount_currency='CFA'
--this statement will select individual users(and not the number of times they may appear in the transfer table) who transacted in CFA.

Question 4
select count(atx_id) from agent_transactions 
where extract(YEAR from when_created)=2018 
group by extract(MONTH from when_created);
--This statement count all agent transactions that occurred in the year 2018 and group them based on the months

Question 5
with mywithdrawers as
(select count(agent_id) netwithdrawers from agent_transactions having count(amount) in
		(select count(amount) from agent_transactions where amount >-1 and amount!=0 having count(amount)>
			(select count(amount) from agent_transactions where amount <1 and amount!=0)))
select netwithdrawers from mywithdrawers where when_created >=NOW()-interval'1week';
with mydepositors as
	(select count(agent_id) netdepositors from agent_transactions having count(amount) in
		(select count(amount) from agent_transactions where amount <1 and amount!=0 having count(amount)>
			(select count(amount) from agent_transactions where amount >-1 and amount!=0)))
select netdepositors from mydepositors where when_created >=NOW()-interval'1week';
--'with mywithdrawers' will help alias the result for counting all agents whose withdrawal amount exceeds deposits amount 
--and vice versa for netdepositors.line 3 will count all the positive transactions and exclude 0 for withdrawals and ensure that it greater than count for all deposit on line 4.
-- the vice versa is for the count of netdepositors.

Question 6
select count(agent_transactions.atx_id) as "atx volume city summary",
agents.city from agent_transactions
left join agents on agent_transactions.agent_id=agents.agent_id
where
agent_transactions.when_created >=NOW()-INTERVAL'1 week'
group by agents.city;
--this code is to display a table containing the count of all agent transactions and add only the city of the agents from the agent table and it's grouped by the city of the agent
Question 7
select count(agent_transactions.atx_id) as "atx volume city summary",
agents.city, agents.country from agent_transactions
left join agents on agent_transactions.agent_id=agents.agent_id
where
agent_transactions.when_created >=NOW()-INTERVAL'1 week'
group by agents.city,agents.country;
-- this is similar to that of question, the difference is the addition of the agents country. this time round, the columns displayed will include the city and country of the agents.

Question 8
select count(transfers.send_amount_scalar)as volume,
transfers.kind,wallets.ledger_location as country
from transfers left join wallets on transfers.source_wallet_id=wallets.wallet_id
where transfers.when_created>= NOW()- interval'1week'
group by transfers.kind, wallets.ledger_location;
--this will display the count of send_amount_scalar based on the kind of transfer and the country where it occured.

Question 9
select count(transfers.send_amount_scalar)as volume,
transfers.kind,wallets.ledger_location as country,
count(transfers.transfer_id) as transaction_count,
count(distinct source_wallet_id) as sender_unique
from transfers left join wallets on transfers.source_wallet_id=wallets.wallet_id
where transfers.when_created>= NOW()- interval'1week'
group by transfers.kind, wallets.ledger_location;
--just as question 8, now the count of all the transactions have been added to the output(line3) and that of wallet_id of all wallets that sent an amount.


Question 10
select source_wallet_id,
			(select send_amount_scalar from transfers where send_amount_scalar >1000000)
from transfers where send_amount_currency ='CFA' and when_created>=NOW()-interval'1month';
--the statement above will retrieve all wallets sending an amount greater than 1000000 specifying the currency in CFA.						