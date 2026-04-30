---
slug: /poscreators/middleware-doc/general/function-structures
title: Function Structures
---

# Function Structures

## iPOS Interface

This interface is a communication channel for interacting with the fiskaltrust.Middleware. It provides three basic functions: "echo", "sign", and "journal". The functions "echo" and "sign" return bare-objects, the function "journal" returns a wrapped-object.

### Echo Function

This function provides fast and easy communication checks. The transferred message is sent back directly.

**Asynchronous _Echo_ call (v1 - Germany and Italy):**
```cs
var request = new ifPOS.v1.EchoRequest { Message = "Message" };
ifPOS.v1.EchoResponse response = await proxy.EchoAsync(request);
```

**Synchronous _Echo_ call (v0 - Austria and France):**
```cs
string result = proxy.Echo("Message");
```

### Sign Function

This is the key function of the fiskaltrust.Middleware. Once the sign function is called, the receipt data is transferred for processing. The result of the processing is then sent back as receipt response.

**Asynchronous _Sign_ call (v1 - Germany and Italy):**
```cs
var request = new ifPOS.v1.ReceiptRequest();
// Fill the properties of the request
ifPOS.v1.ReceiptResponse response = await proxy.SignAsync(request);
```

**Synchronous _Sign_ call (v0 - Austria and France):**
```cs
var request = new ifPOS.v0.ReceiptRequest();
// Fill the properties of the request
ifPOS.v0.ReceiptResponse response = proxy.Sign(request);
```

### Journal Function

With this function, a variety of information can be retrieved from the fiskaltrust.Middleware, ranging from the status information to a general notifications protocol.

**Asynchronous _Journal_ call (v1 - Germany and Italy):**
```cs
var request = new ifPOS.v1.JournalRequest();
// Fill the properties of the request
await foreach (var response in proxy.JournalAsync(request))
{
    byte[] arr = response.Chunk.ToArray();
    // Handle resulting byte chunk by e.g. writing it to a file
}
```

**Synchronous _Journal_ call (v0 - Austria and France):**
```cs
Stream stream = proxy.Journal(ftJournalType, 0, DateTime.UtcNow.Ticks);
```

A list with possible values for the request parameter ftJournalType is provided in the reference table ["Type of Journal: ftJournalType"](../reference-tables/reference-tables.md#type-of-journal-ftjournaltype). The journal depends on national requirements and therefore the function has to run in the appropriate mode: exporting data in chunks, or as a whole.

#### REST endpoint

When using the REST communication protocol, the journal function is available at the following URL:

```
POST http://[base-url]/[json|xml]/[v0|v1]/journal
```

The request parameters are passed as **URL query string parameters** (the request body is ignored for the on-premise Middleware REST endpoint):

| Parameter | Description |
|-----------|-------------|
| `type`    | The journal type (`ftJournalType`). See the reference table ["Type of Journal: ftJournalType"](../reference-tables/reference-tables.md#type-of-journal-ftjournaltype) for possible values. |
| `from`    | Start timestamp as [.NET Ticks](#timestamps). Use `0` to retrieve data from the beginning. |
| `to`      | End timestamp as [.NET Ticks](#timestamps). Use `DateTime.UtcNow.Ticks` to retrieve data up to the current moment. |

**Required headers:**
- `content-type: text/plain`
- For cloud-hosted services: `cashboxid` (CashBox ID) and `accesstoken` (access token)

**Sample REST journal request (version information):**
```
POST http://localhost:1500/a4c4e466-721a-4011-a9a5-a23827a21b45/json/v1/journal?type=0&from=0&to=638800000000000000
Content-Type: text/plain
```

The response is a raw byte stream. The format and content of the response depend on the requested `ftJournalType` value — for example, `type=0` returns a JSON string with version information, while exports (e.g., DSFinV-K or TAR files for Germany) return a binary archive. Refer to the country-specific documentation for the expected output format per journal type.

:::info

On Linux (Mono), the `/json/v1` version prefix is not included in the URL. See the [Linux platform documentation](../../middleware-de-kassensichv/operation-modes/on-premise-platforms/linux.md#rest-limitations) for details.

When using the cloud-hosted **POS API** (`pos-api.fiskaltrust.cloud`) instead of the on-premise Middleware, the parameters are sent in the JSON request body rather than as query string parameters. See the [POS API documentation](../../digital-receipt/implementation/digital-receipt-implementation.md#retrieve-journal-data-journal-endpoint) for details.

:::

#### Timestamps

The journal function expects the timestamps to be [.NET Ticks](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.ticks?view=net-5.0#remarks).

The following conversion formulas can be used to convert between unix time and .NET Ticks:

| Conversion             | Formula                                    |
|------------------------|--------------------------------------------|
| `unix time` -> `Ticks` | `621355968000000000 + unixtime * 10000000` |
| `Ticks` -> `unix time` | `(ticks - 621355968000000000) / 10000000`  |
