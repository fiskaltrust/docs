---
slug: /poscreators/middleware-doc/poland/scu/posnet
title: POSNET-Printer
description: POSNET Online printer SCU for Poland (preview) — connection over network, serial port or USB, parameters, supported receipt cases, how failures are handled without duplicate fiscal receipts, the printer status on the zero receipt, and development without a device.
tags: [POSNET, SCU, Configuration, Poland]
---

# POSNET Printer

## Signature Creation Unit

### Support

**Status:** in development (preview) — tracked in [fiskaltrust/middleware#751](https://github.com/fiskaltrust/middleware/issues/751)

The _fiskaltrust.Middleware.SCU.PL.PosNet_ package connects the middleware with a **POSNET Online fiscal printer**. The printer is the certified register: it assigns the fiscal document numbers, owns the PTU (VAT) rate table and the daily (Z) reports, and transmits the fiscal data to the CRK. The SCU translates the middleware receipt into POSNET protocol commands and returns the register's identifiers on the response (see [Type of Signature: ftSignatureType](../../reference-tables/type-of-signature-ftsignaturetype.md)).

The devices on which the SCU has been tested are listed on the [Data Structures](../../data-structures/data-structures.md) page.

### Connection

The SCU communicates with the printer using the POSNET Online protocol (framed, checksummed request/response exchange). The parameter `DeviceUrl` selects the connection:

| Connection | `DeviceUrl` | Notes |
|------------|-------------|-------|
| Network | `tcp://192.168.1.50:6666` | The network interface of the printer. |
| Serial port or USB virtual COM port | `serial://COM9`, `usb://COM9`, `/dev/ttyACM0` | The printer's PC interface set to USB or RS-232. |
| USB on Android | `usbhost://1424:10B0` | Vendor and product ID of the printer, in hex. The fiskaltrust Android launcher opens the printer through the Android USB host API; Android asks the user once to allow access to the printer. |

*Table 1. Connections to the POSNET printer.*

### Parameters

| Name | Description | Default | Optional |
| ---- | ----------- | ------- | -------- |
| DeviceUrl | The address of the POSNET printer, see [Connection](#connection). | | mandatory |
| ConnectTimeoutMs | Time to establish the connection, in milliseconds. | `5000` | optional |
| SendTimeoutMs | Time to send a command, in milliseconds. | `5000` | optional |
| ReceiveTimeoutMs | Time to wait for the answer to a command, in milliseconds. | `15000` | optional |
| SerialBaudRate, SerialParity, SerialStopBits, SerialHandshake | Serial line settings for `serial://`, `usb://` and `usbhost://`. A `usbhost://` printer gets them as its line coding; the handshake does not apply there. | `115200`, `None`, `1`, `None` | optional |
| VatRateTable | The PTU (VAT) rate table. If empty, the SCU uses the table the printer reports. | empty | optional |
| OutcomeResolutionPollIntervalMs | Pause between two status reads while the SCU waits for the printer to finish a document it did not confirm, in milliseconds. See [Failure handling](#failure-handling). | `1000` | optional |

*Table 2. Parameters of the POSNET SCU.*

Please pay attention to the case-sensitive use of the parameters. A parameter with a wrong value is rejected with a validation error that names the parameter.

### Scope of the preview

In the preview, the SCU processes the following receipt cases:

| Receipt case | What the printer does |
|--------------|-----------------------|
| POS receipt `0x0001`, unknown `0x0000`, e-commerce `0x0004` | Prints the fiscal receipt (*paragon fiskalny*), including discounts and extras (see [Discounts and extras](../../data-structures/data-structures.md#discounts-and-extras)) and the [additional lines](../../data-structures/data-structures.md). |
| POS receipt with the flag `IsReturn/IsRefund` | Prints the return as a document of its own, see [Sale and return positions](../../data-structures/data-structures.md#sale-and-return-positions). |
| Zero receipt `0x2000` | Prints nothing. Returns the printer status, see [Printer status on the zero receipt](#printer-status-on-the-zero-receipt). |
| Daily closing `0x2011` | Prints the daily report (*raport dobowy*). |
| Monthly closing `0x2012` | Prints the monthly report of the month of `cbReceiptMoment`, converted to Polish time (Europe/Warsaw). |
| Yearly closing `0x2013` | Prints a periodic report from 1 January up to the day of `cbReceiptMoment`, converted to Polish time (Europe/Warsaw); the printer has no yearly report of its own. Send it on 31 December, Polish time, to cover the whole year: for example, `2026-12-31T23:30:00Z` is already 1 January 2027 in Poland. |
| Invoices `0x1xxx` | Not sent to the printer. A Polish invoice is issued through KSeF. |

*Table 3. Receipt cases processed by the POSNET SCU.*

The initial-operation receipt checks that the printer reports itself as fiscalized; device fiscalization and one-time setup (header, VAT table) remain certified-technician (*serwis*) acts. In the sandbox, a printer that reports itself as not fiscalized is accepted too, so that integrations can be tested on demo hardware.

### Failure handling

A POSNET printer accepts a whole receipt even when it cannot print, for example with the cover open or without paper. It then holds the closed receipt and prints and fiscalizes it as soon as the fault is cleared. No command withdraws such a receipt. The SCU therefore never reports a receipt as *not issued* while the printer may still issue it:

- Before a receipt is opened and before it is closed, the SCU checks that the printer is ready. If it is not, the receipt is **not issued** and the response is an error.
- Every failure before the receipt is closed means that the receipt was not issued; the SCU cancels the open receipt. The error message says "The receipt was NOT issued", and the POS can send the receipt again.
- If the printer does not confirm closing the receipt, the SCU waits until the printer is ready again and then reads its counters: if the receipt was issued, the response is successful as for any other receipt; if not, the response is an error. There is no time limit on this wait, because an answer given while the printer still holds the receipt could be wrong. The Queue processes requests one at a time, so a zero receipt sent to the same Queue waits until the pending receipt is answered; check the printer itself (paper, cover, cable) to see what it is waiting for.
- After the receipt is closed, nothing fails it: if the connection is lost before the SCU has read the receipt's numbers, it waits for the printer and reads them again. A failure while printing the additional lines is reported in the response, see [Additional lines on the receipt](../../data-structures/data-structures.md).
- The daily closing is handled in the same way; its error message says "The daily report was NOT issued".
- If the printer is ready again but does not report the counters needed to decide, the outcome is **unknown**: the `FAILURE` signature says so. Check the last document on the printer before sending the request again, and send it again only if it was not issued.

Errors are returned with the state `0x504C_2000_EEEE_EEEE` (see [Service Status: ftState](../../reference-tables/service-status-ftstate.md)) and a signature of the failure category that says what to do next: for an SCU or printer error its caption is `FAILURE`; for a validation error of the Queue the caption names the rule, such as `[Error] CurrencyMustMatchMarket`. Read the `Data` of every signature of the failure category.

### Printer status on the zero receipt

The zero receipt (`0x2000`) returns the live state of the printer in `ftStateData`, under `PL.PosNet.PrinterStatus`. The fields are specific to POSNET printers; the `PosNet` level names the device family. It is processed after any request that is still pending in the same Queue:

```json
"ftStateData": {
  "PL": {
    "PosNet": {
      "PrinterStatus": {
        "Ready": true,
        "Problem": null,
        "Mechanism": 0,
        "MechanismText": "ready",
        "DeviceStatus": 0,
        "DeviceStatusText": "ready",
        "QueueEmpty": true,
        "PaperNearEnd": false,
        "TransactionOpen": false,
        "FiscalMode": false,
        "ReadOnlyMode": false,
        "UniqueDeviceNumber": "ZBF 2101002396",
        "DeviceType": "POSNET THERMAL XL2 ONLINE",
        "SoftwareVersion": "30.01"
      }
    }
  }
}
```

| Field | Description |
|-------|-------------|
| `Ready` | The printer is ready for the next receipt. |
| `Problem` | Why the printer is not ready, in words, for example an open cover or missing paper. `null` if it is ready. |
| `Mechanism`, `MechanismText` | State of the printing mechanism. |
| `DeviceStatus`, `DeviceStatusText` | State of the device, for example waiting for the operator. |
| `QueueEmpty` | All commands sent to the printer are executed. |
| `PaperNearEnd` | The paper roll is nearly empty. |
| `TransactionOpen` | A receipt is open on the printer. |
| `FiscalMode`, `ReadOnlyMode` | The printer is fiscalized; the printer is in read-only mode. |
| `UniqueDeviceNumber` | The unique number of the printer (*numer unikatowy*). |
| `DeviceType`, `SoftwareVersion` | The model and the software version of the printer. |

*Table 4. Fields of `PL.PosNet.PrinterStatus`.*

`FiscalMode`, `ReadOnlyMode`, `UniqueDeviceNumber`, `DeviceType` and `SoftwareVersion` are only read while the printer is ready; otherwise they are `null`. A printer that does not answer at all makes the zero receipt fail.

### Development without a device

For development and integration tests without a physical printer, the Polish sandbox provides a fake register with the same `IPLSSCD` behavior (used by the CloudCashbox sandbox and the developer sample) — no POSNET hardware is required to integrate against the Polish market.
