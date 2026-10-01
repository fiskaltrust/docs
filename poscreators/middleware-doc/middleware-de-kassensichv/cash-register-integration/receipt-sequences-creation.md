---
slug: /poscreators/middleware-doc/germany/receipt-sequences-creation
title: Receipt Sequences Creation
---

# Receipt Sequences Creation

In the chapter [Single receipt creation](single-receipt-creation.md), the creation of single receipts using either implicit and/or explicit flow has been described.

In this chapter, we will describe how to connect those single receipts to receipt sequences to integrate complex business cases.

### Why and when is this needed?

Suppose orders, delivery notes, invoices and payments are being processed at different times, and the electronic recording system processes the business action not as a whole but in separate processes. 

In that case, the business activities and other activities **must be traceable in their creation and processing**, and a unique identification number for the business action must exist.
The same applies if different electronic recording systems are used in the course of the business action. 

## Referencing previous actions within a queue

#### Use case examples

- Multiple (long lasting) transactions/orders/consumptions before payment is made (gastronomy, ...)
- NFC-based/membership-based order solutions (e.g. accommodation/wellness, employee cards)
- Down payments

#### How to use

Connect requests representing a business action with ['cbReceiptReference'](../data-structures/data-structures.md#single-fields).

#### Workflow example

```mermaid
flowchart TD
  accTitle: Referencing previous receipts
  accDescr: Two friends order two rounds of beer as two INFO-ORDER requests and then ask for the bill with a POS-RECEIPT, all three using cbReceiptReference = 123 to reference the same business action.
  S1(["2 Friends ordering<br/>the first round of beer"])
  R1["INFO-ORDER<br/>cbReceiptReference = 123<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  R2["INFO-ORDER<br/>cbReceiptReference = 123<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  R3["POS-RECEIPT<br/>cbReceiptReference = 123<br/>---<br/>CHARGE ITEMS: 4 beer<br/>PAY ITEMS: payment data<br/>Implicit Flow"]
  S1 ==> R1
  R1 == "order of the second<br/>round of beer" ==> R2
  R2 == "&quot;The bill, please&quot;" ==> R3
  R2 -. cbReceiptReference .-> R1
  R3 -. cbReceiptReference .-> R1
```

*Figure 1. Workflow for referencing previous receipts within a queue.*

Two friends are having a beer in a bar.  Because it is good German beer, they are ordering another one. They pay with one bill.

#### Code examples

Code examples of receipt sequences can be found in our [Postman collection](https://middleware-samples.docs.fiskaltrust.cloud/#e9b0b712-2dda-4c4c-a061-16d72daa723b).

## Splitting actions

#### Use case examples

- pos-receipt(s) paid by multiple people
- Voiding/cancelling receipts
- Correction of orders (f.e. gastronomy)

#### How to use

Use ['cbReceiptPreviousReference'](../data-structures/data-structures.md#single-fields) to point to a 'cbReceiptReference' of a previous request to split or void a receipt.

#### Workflow example

```mermaid
flowchart LR
  accTitle: Splitting receipts
  accDescr: Two friends order beer as one INFO-ORDER with cbReceiptReference = 124, and when each pays his own consumption, two POS-RECEIPTs (cbReceiptReference 125 and 126) point back to the order via cbPreviousReceiptReference = 124.
  S1(["2 Friends ordering<br/>beer"])
  R1["INFO-ORDER<br/>cbReceiptReference = 124<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  B(["&quot;The bill, please.<br/>Each of us pays his<br/>own consumption.&quot;"])
  R2["POS-RECEIPT<br/>cbReceiptReference = 125<br/>cbPreviousReceiptReference = 124<br/>---<br/>CHARGE ITEMS: 1 beer<br/>PAY ITEMS: payment data<br/>Implicit Flow"]
  R3["POS-RECEIPT<br/>cbReceiptReference = 126<br/>cbPreviousReceiptReference = 124<br/>---<br/>CHARGE ITEMS: 1 beer<br/>PAY ITEMS: payment data<br/>Implicit Flow"]
  S1 ==> R1
  R1 ==> B
  B ==> R2
  B ==> R3
  R2 -. cbPreviousReceiptReference .-> R1
  R3 -. cbPreviousReceiptReference .-> R1
```


*Figure 2. Workflow for splitting a receipt among multiple payers.*

Two friends are having a beer in a bar.  Each of them is paying his own consumption. Therefore, the receipt has to be split.

### Code examples

Code examples of splitting receipts can be found in our [Postman collection](https://middleware-samples.docs.fiskaltrust.cloud/#86967a8f-a1fe-4262-975e-c4a155209cb3).

## Merging actions

#### Use case examples

- invitation
- if you need to invoice more than one purchase receipt at a time/it can be paid all together

#### How to use

Merge receipts by combining ['cbReceiptReference' and 'cbReceiptPreviousReference'](../data-structures/data-structures.md#single-fields). Use ftReceiptCase 'Info-internal' to create a new 'cbReceiptReference' and refer via 'cbPreviousReceiptReference' to the order you want to merge. Repeat this for each order you want to merge using the same 'cbReceiptReference' and using 'cbPreviousReceiptPreference' to point to the order to be merged.

#### Workflow example

```mermaid
flowchart TD
  accTitle: Merging receipts
  accDescr: Two separate INFO-ORDERs (cbReceiptReference 127 and 128) are each referenced by an INFO-INTERNAL request with the shared cbReceiptReference = 129 via cbPreviousReceiptReference, and both are merged into one POS-RECEIPT with cbReceiptReference = 129.
  S1(["2 Friends ordering<br/>the first round of beer"])
  S2(["4 people want to<br/>consume cocktails"])
  O1["INFO-ORDER<br/>cbReceiptReference = 127<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  O2["INFO-ORDER<br/>cbReceiptReference = 128<br/>---<br/>CHARGE ITEMS: 4 cocktails<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  I1["INFO-INTERNAL<br/>cbReceiptReference = 129<br/>cbPreviousReceiptReference = 127<br/>---<br/>CHARGE ITEMS: (empty)<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  I2["INFO-INTERNAL<br/>cbReceiptReference = 129<br/>cbPreviousReceiptReference = 128<br/>---<br/>CHARGE ITEMS: (empty)<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  P["POS-RECEIPT<br/>cbReceiptReference = 129<br/>---<br/>CHARGE ITEMS: 2 beer, 4 cocktails<br/>PAY ITEMS: payment data<br/>Implicit Flow"]
  S1 ==> O1
  O1 == "they invite the table<br/>next to them" ==> I1
  S2 ==> O2
  O2 == "they get invited from<br/>the table next to them" ==> I2
  I1 <-. cbReceiptReference = 129 .-> I2
  I1 ==> P
  I2 ==> P
```


*Figure 3. Workflow for merging receipts of separate business actions.*

Two friends are having a beer in a bar. One of them has birthday. To celebrate that, he invites the guests on the table next to them to pay what they have ordered and consumed so far. Therefore, their receipt has to be merged with the other receipt.

#### Code examples

Code examples of merging receipts can be found in our [Postman collection](https://middleware-samples.docs.fiskaltrust.cloud/#b81fedc6-919a-46e4-899a-52582606a6d7).

## Changing the area in which the receipt is created

#### Use case examples

Changing the area of value creation; e.g.

- Consumption in Restaurant-Hotel -> Restaurant-Wellness -> Bar-Sauna
- Moving between different tables within a Restaurant
- Providing information how business actions are connected to each other across multiple POS-Systems

#### How to use

Document the field/section in which the receipt is created with [cbArea](../../general/data-structures/data-structures.md).

#### Workflow example

```mermaid
flowchart TD
  accTitle: Switching cbArea
  accDescr: Two friends order beer at cbArea Table 21 (cbReceiptReference = 130), move to Table 22 and order another 2 beer with a new INFO-ORDER that keeps cbReceiptReference = 130, while 4 new guests at Table 21 start a new order with cbReceiptReference = 131.
  subgraph T21["cbArea = Table 21"]
    direction TB
    S1(["2 Friends ordering<br/>the first round of beer"])
    O1["INFO-ORDER<br/>cbReceiptReference = 130<br/>cbArea = Table 21<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
    S3(["4 new guests sit on<br/>the empty table 21<br/>and order some food"])
    O3["INFO-ORDER<br/>cbReceiptReference = 131<br/>cbArea = Table 21<br/>---<br/>CHARGE ITEMS: 4 Wiener Schnitzel<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  end
  subgraph T22["cbArea = Table 22"]
    direction TB
    S2(["they order another<br/>2 beer"])
    O2["INFO-ORDER<br/>cbReceiptReference = 130<br/>cbArea = Table 22<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  end
  S1 ==> O1
  O1 == "they move to table 22" ==> S2
  S2 ==> O2
  S3 ==> O3
  O1 -. cbReceiptReference = 130 .-> O2
```


*Figure 4. Workflow for changing the area (cbArea) in which a receipt is created.*

Two friends are having a beer in a bar on a big table. They change to a smaller table so that a bigger group of people can sit on their previous table to order some food.

## Referencing actions of external queues or external Systems

#### Use case examples

Multiple POS-Systems are involved in the business action and only one of them is used for invoice/receipt creation, e.g.:

- Restaurant/Bar using multiple queues; orders are done with one queue and payment with another queue
- Restaurant/Wellness/Hotel using different POS-Systems; one system is used for final invoice creation
- Membership cards/vouchers with multiple POS-Systems involved

### Option A: ChargeItems collected via "internal" queue are paid at an external system or queue

#### How to use

ChargeItems are collected via ftReceiptCase 'Info-internal' or 'Info-order'. 'cbArea' can be used as an identifier for documenting the business action across multiple POS-Systems. The obligation to issue receipts arises at the external POS-System.

#### Workflow example

```mermaid
flowchart TD
  accTitle: Charge items internal, payment external
  accDescr: A couple checks in at the hotel on the external POS-System (INFO-ORDER Room 234), has a beer at the hotel bar recorded on the internal POS-System as INFO-INTERNAL with cbReceiptReference = 101 and cbArea = Room 234, and pays at checkout on the external POS-System, which issues the POS RECEIPT.
  subgraph INT["internal POS-System<br/>Hotel bar"]
    direction TB
    I1["INFO-INTERNAL<br/>cbReceiptReference = 101<br/>cbArea = Room 234<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
  end
  subgraph EXT["external POS-System<br/>Hotel accomodation"]
    direction TB
    S1(["A couple checks in<br/>in a hotel for 1 night"])
    E1["external POS-System<br/>INFO-ORDER<br/>Room 234"]
    S2(["checkout"])
    E2["external POS-System<br/>POS RECEIPT<br/>Room 234"]
  end
  S1 ==> E1
  E1 == "They have a beer<br/>at the Hotel bar.<br/>Consumption should be paid<br/>via accommodation<br/>invoice / checkout." ==> I1
  I1 ==> S2
  S2 ==> E2
  E1 -. Room 234 .-> I1
  I1 -. Room 234 .-> E2
```


*Figure 5. Workflow where charge items collected via an internal queue are paid at an external system.*

A couple checks in to a hotel for one night. They have a beer at the hotel bar, which uses a different POS-System than at the reception. The couple wishes the consumption to be paid via accommodation invoice at checkout. Therefore, an 'info-internal' is used instead of a 'POS receipt'. 'cbArea' is used to provide the information about the connected business action using the room number as unique identifier.

### Option B: ChargeItems collected at an external system or queue are paid at the internal queue

#### How to use

Use 'info-internal' with ['ftReceiptCaseData' according to the requirements of the DSFinV-K-specification](../procedural-documentation/dsfinv-k-generation.md#file-bon_referenzen-referencescsv) to reference to an business-action recorded by an external queue or POS-System which needs to be merged with your ongoing internal business-action. By creating a new 'cbReceiptReference', you create the precondition to merge the receipt the external system with your internal receipts of the ongoing business-action. Repeat this step to collect and reference to multiple external POS-Systems with related business-actions to be charged. The obligation to issue receipts arises at the POS-System where the POS receipt is being created.

##### Prerequisites

For this workflow, the combination of following receipt-sequences is needed:

- Referencing previous receipts within a queue, using 'cbReceiptReference',
- Merging receipts, using 'cbReceiptreference' and 'cbPreviousReceiptReference',
- Providing additional information about how the business actions are connected to each other, using 'cbArea',
- Providing information about the external POS receipt, using 'ftReceiptCaseData'

#### Workflow example

```mermaid
flowchart TD
  accTitle: Charge items external, payment internal
  accDescr: A couple checks in on the internal POS-System (INFO-ORDER cbReceiptReference = 100, Room 234), has a beer recorded on an external queue or POS-System, which is referenced via INFO-INTERNAL with ftReceiptCaseData, and at checkout the overnight stay and the 2 beer are included in the final POS-RECEIPT on the internal POS-System.
  subgraph EXT["external POS-System<br/>Hotel bar"]
    direction TB
    X1["External queue or POS-System<br/>INFO-INTERNAL<br/>Room 234<br/>---<br/>CHARGE ITEMS: 2 beer<br/>PAY ITEMS: (empty)<br/>additional/footer data"]
  end
  subgraph INT["internal POS-System<br/>Hotel accomodation"]
    direction TB
    S1(["A couple checks in<br/>in a hotel for 1 night"])
    O1["INFO-ORDER<br/>cbReceiptReference = 100<br/>cbArea = Room 234<br/>---<br/>CHARGE ITEMS: overnight stay 1 night<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
    I1["INFO-INTERNAL<br/>cbReceiptReference = 101<br/>ftReceiptCaseData = data of<br/>external POS-System<br/>cbArea = Room 234<br/>---<br/>CHARGE ITEMS: (empty)<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
    S2(["checkout"])
    I2["INFO-INTERNAL<br/>cbReceiptReference = 101<br/>cbPreviousReceiptReference = 100<br/>cbArea = Room 234<br/>---<br/>CHARGE ITEMS: (empty)<br/>PAY ITEMS: (empty)<br/>Implicit Flow"]
    P["POS-RECEIPT<br/>cbReceiptReference = 101<br/>cbArea = Room 234<br/>---<br/>CHARGE ITEMS: overnight stay<br/>1 night, 2 beer<br/>PAY ITEMS: payment data<br/>Implicit Flow"]
  end
  S1 ==> O1
  O1 == "They have a beer<br/>at the Hotel bar.<br/>Consumption should be paid<br/>via accommodation<br/>invoice / checkout." ==> X1
  X1 == "overnight stay" ==> I1
  S2 ==> I2
  I1 ==> P
  I2 ==> P
  X1 -. ftReceiptCaseData .-> I1
  X1 -. "CHARGE ITEMS: 2 beer" .-> P
```


*Figure 6. Workflow where charge items collected at an external system are paid at the internal queue.*

1. A couple performs a check-in at the reception of a hotel for one night.
2. An info-order for the overnight-stay is created.
3. After the check-in, it decides to have a beer at the hotel-bar, which uses a different POS-System (or fiskaltrust.queue). The consumption of the hotel-bar shall be paid with the final invoice of the overnight-stay. The room number is for 'cbArea' to provide information why the business actions across the different POS-Systems are connected. 
4. For the check-out, the receipt of the consumption of the hotel-bar and the receipt of the overnight stay need to be merged. Therefore, 'info-internal' receipts with a new, common 'cbReceiptReference' are created. One 'info-internal' receipt is used to reference to the external POS receipt using 'ftReceiptCaseData'. 
5. The other 'info-internal' receipt is used to reference to the internal 'info-order' of the overnight-stay using 'cbPreviousReceiptReference'. 
6. A 'POS receipt' is created, including all collected charge-items from external and internal POS-System(s), and the pay-items of the internal POS-System. The receipt is printed and handed over to the couple.

#### Code examples

Code examples of referencing external receipts can be found in our [Postman collection](https://middleware-samples.docs.fiskaltrust.cloud/#06a34ac5-7c4f-441e-ba2b-4f02badc409c).

## Money substitutes based sequences (vouchers, membership cards,...)

### Issuing and redeeming multi-purpose vouchers/cards

#### Use case examples

- Consumption in Hospitality/Wellness/Spa with cards/bracelets
- Use of employee cards in cafeteria/canteen
- Multi-purpose vouchers

#### How to use

Issuing and redeeming a multi-purpose voucher can be achieved with charge- and payitems or within payitems only as shown in [following examples](https://middleware-samples.docs.fiskaltrust.cloud/#ef0d52d6-ac2f-4c75-b16c-d4d1380e3257) in the Postman collection. 

#### Workflow

```mermaid
flowchart TD
  accTitle: Multi-purpose voucher
  accDescr: Sequence of four POS-RECEIPTs in which a customer charges 100 euros on an NFC bracelet as a multi-purpose voucher, redeems it for a cocktail and a scuba diving session, and has the remaining credit paid out, with the voucher recorded in the pay items.
  S1(["Customer in Club Med<br/>charges 100 €<br/>on his bracelet"])
  R1["POS-RECEIPT<br/>cbReceiptReference = 333<br/>cbArea = Reception<br/>---<br/>CHARGE ITEMS: (empty)<br/>PAY ITEMS:<br/>Multi-purpose voucher purchase:<br/>- 100 €<br/>ftPayItemCaseData: ItemCaseName<br/>&quot;NFC-bracelet Nr. 321&quot;<br/>payment: 100 €<br/>Implicit Flow"]
  S2(["Customer consumes<br/>one cocktail"])
  R2["POS-RECEIPT<br/>cbReceiptReference = 526<br/>cbArea = Pool-Bar<br/>---<br/>CHARGE ITEMS: One cocktail: 10 €<br/>PAY ITEMS:<br/>Multi-purpose voucher redemption:<br/>100 €<br/>ftPayItemCaseData: ItemCaseName<br/>&quot;NFC-bracelet Nr. 321&quot;<br/>payment: - 90 €<br/>Implicit Flow"]
  S3(["Customer consumes<br/>a scuba diving session"])
  R3["POS-RECEIPT<br/>cbReceiptReference = 34<br/>cbArea = Scuba Diving School<br/>---<br/>CHARGE ITEMS: One Scuba Diving<br/>session: 60 €<br/>PAY ITEMS:<br/>Multi-purpose voucher redemption:<br/>90 €<br/>ftPayItemCaseData: ItemCaseName<br/>&quot;NFC-bracelet Nr. 321&quot;<br/>payment: - 30 €<br/>Implicit Flow"]
  S4(["Customer wants to<br/>have the credit<br/>paid out"])
  R4["POS-RECEIPT<br/>cbReceiptReference = 356<br/>cbArea = Reception<br/>---<br/>CHARGE ITEMS: (empty)<br/>PAY ITEMS:<br/>Multi-purpose voucher redemption:<br/>30 €<br/>ftPayItemCaseData: ItemCaseName<br/>&quot;NFC-bracelet Nr. 321&quot;<br/>payment: 0 €<br/>Implicit Flow"]
  S1 ==> R1 ==> S2 ==> R2 ==> S3 ==> R3 ==> S4 ==> R4
```


*Figure 7. Workflow for issuing and redeeming a multi-purpose voucher across POS-Systems.*

A customer at Club Med charges his bracelet with 100 €, which is used within the club area as a money substitute. Multiple consumptions are made using different POS-Systems. Each POS-System uses its own different POS receipt IDs, and 'cbArea' is changing as well. At check-out, the customer is getting paid out the remaining credit on the bracelet. 

In this example, we are using the payitem option for managing the multi-purpose voucher transactions. A negative amount of 'ftPayItemCase' `0x444500000000000D` gets converted to a multi-purpose voucher purchase. 'ftPayItemCaseData' is being used to add the additional information of the use of the NFC-bracelet (e.g."NFC-bracelet NR. 321"). In this case, the NFC-bracelet can be used as identifier across multiple involved POS-Systems.

After charging the bracelet, the customer redeems the voucher in several cases. A positive amount of 'ftPayItemCase' `0x444500000000000D` gets converted to a multi-purpose voucher redemption. The negative amount of payment indicates the credit available after the redemption.

In the last business action, the customer wants to have his credit paid out. The positive amount of 'ftPayItemCase' `0x444500000000000D` is set to the actual credit value so that the payment amount is zero.

#### Code examples

- [Issuing](https://middleware-samples.docs.fiskaltrust.cloud/#c8cba72c-6fbe-4e34-b47d-2fc498d12c2f) and [redeeming](https://middleware-samples.docs.fiskaltrust.cloud/#fa77f359-eda8-4686-8c70-efb125058985) multi-purpose voucher using pay-items

- [Issuing](https://middleware-samples.docs.fiskaltrust.cloud/#ee38c78e-a056-440c-ac46-ec1926bc92ad) and [redeeming](https://middleware-samples.docs.fiskaltrust.cloud/#58e9564f-c9bc-4920-8740-f3e468db1b2f) multi-purpose voucher using charge- and pay-items
