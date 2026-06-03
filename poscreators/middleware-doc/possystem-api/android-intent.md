---
slug: /poscreators/possystem-api/android-intent
title: Android Intent Integration
---

# Android Intent Integration

## Overview

This document describes the Android intent call interface for unlocking offline capability of the fiskaltrust.Middleware. The POS System API provides a standardized REST API for Point of Sale (POS) systems/Electronic Cash Register (ECR) systems to interact with fiscal middleware services across multiple European markets (Austria, Germany, France, Italy, Greece, Spain, Portugal, Belgium).

By using Android intents, mobile applications can communicate with the fiskaltrust.Middleware running side-by-side on Android devices to perform fiscal operations even without an active internet connection.

To test the Android integration with the latest preview build, download the [Preview APK of the Android Launcher](https://downloads.fiskaltrust.cloud/downloads/android/fiskaltrust-middleware-launcher-android/preview/eu.fiskaltrust.androidlauncher-Signed.apk).

### Key Features

- **Offline fiscalization**: Perform fiscal operations without internet connectivity
- **Multi-market compliance**: Support for AT, DE, FR, IT, GR, ES, PT, BE fiscal requirements
- **Synchronous operation mode**
- **Idempotent operations**: Safe retry mechanism with operation IDs
- **State-based operation tracking**: Monitor operation progress

### API Version

This documentation is based on the [fiskaltrust PosSystemAPI v2.1](https://docs.fiskaltrust.cloud/apis/pos-system-api-v21) specification.

## Architecture Overview

The PosSystemAPI v2 uses a state-based operation model where each operation follows a lifecycle:

```
Pending → Processing → Done/Failed
```

Operations are identified by a unique `x-operation-id` header, enabling idempotent retries and duplicate detection.

### Operation Modes

**Synchronous Mode**: Send request to `/v2/{endpoint}` and receive the response directly via `startActivityForResult()`.

All operations in this documentation use the synchronous mode for simplicity and immediate responses. If there is a breakdown in communication, the POS system can retry the operation using the same `x-operation-id`.

## Android Intent Integration

### Intent Action Format

Android intents to communicate with fiskaltrust.Middleware follow this pattern:

```
className: "eu.fiskaltrust.androidlauncher.PosSystemAPI"
package: "eu.fiskaltrust.androidlauncher"
```

**Important**: Always use **explicit intents** by specifying the package name for security:

```kotlin
val intent = Intent()
intent.setClassName("eu.fiskaltrust.androidlauncher", "eu.fiskaltrust.androidlauncher.PosSystemAPI")
// Note: Using setClassName for explicit targeting of the PosSystemAPI activity
```

### Intent Extras Structure

All API calls use the following intent extras:

| Extra Key | Type | Required | Description |
|-----------|------|----------|-------------|
| `Method` | String | Yes | HTTP method ("POST", "GET", "PUT", "DELETE") |
| `Path` | String | Yes | API path (e.g., "/echo", "/sign", "/pay" for latest version; e.g., "/v2/echo", "/v2/sign", "/v2/pay" for v2 specific) |
| `HeaderJsonObjectBase64Url` | String | Yes | Base64URL-encoded JSON headers object (includes authentication, content-type, etc.) |
| `BodyBase64Url` | String | No* | Base64URL-encoded request body |

* Empty strings in `BodyBase64Url` indicate no body content for methods like GET or DELETE.

**Note on Base64URL encoding**: All data is Base64URL-encoded to avoid character encoding issues and handle binary data safely. Use standard Base64URL encoding (RFC 4648 §5) which replaces `+` with `-` and `/` with `_`, with no padding.

### Complete Intent Call Example

Here's a complete example showing how to make an intent call with proper Base64URL encoding:

**Kotlin Example:**

```kotlin
import android.content.Intent
import android.util.Base64
import org.json.JSONObject

fun callPosSystemAPI(method: String, path: String, headers: Map<String, String>, body: String?) {
    // Create headers JSON
    val headersJson = JSONObject(headers).toString()
    
    // Base64URL encode (no padding, replace + with -, / with _)
    val headerB64 = headersJson.toByteArray(Charsets.UTF_8)
        .let { Base64.encodeToString(it, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP) }
    
    val bodyB64 = body?.toByteArray(Charsets.UTF_8)
        ?.let { Base64.encodeToString(it, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP) }
    
    // Create intent
    val intent = Intent()
    intent.setClassName("eu.fiskaltrust.androidlauncher", "eu.fiskaltrust.androidlauncher.PosSystemAPI")
    intent.putExtra("Method", method)
    intent.putExtra("Path", path)
    intent.putExtra("HeaderJsonObjectBase64Url", headerB64)
    if (bodyB64 != null) {
        intent.putExtra("BodyBase64Url", bodyB64)
    }
    
    startActivityForResult(intent, REQUEST_CODE)
}

// Example: Echo call
fun echoExample() {
    val headers = mapOf(
        "Accept" to "application/json",
        "x-cashbox-id" to "de12c75f-5587-48b8-8ac5-64b7c81a05ec",
        "x-cashbox-accesstoken" to "your-access-token",
        "x-operation-id" to java.util.UUID.randomUUID().toString(),
    )
    val body = """{"Message": "Hello, World!"}"""
    
    callPosSystemAPI("POST", "/echo", headers, body)
}

override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    
    if (requestCode == REQUEST_CODE && data != null) {
        val statusCode = data.getStringExtra("StatusCode") ?: "500"
        val contentB64 = data.getStringExtra("ContentBase64Url") ?: ""
        val contentTypeB64 = data.getStringExtra("ContentTypeBase64Url") ?: ""
        
        // Decode Base64URL
        val content = Base64.decode(contentB64, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
            .toString(Charsets.UTF_8)
        val contentType = Base64.decode(contentTypeB64, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
            .toString(Charsets.UTF_8)
        
        Log.i("PosSystemAPI", "Status: $statusCode, Type: $contentType")
        Log.i("PosSystemAPI", "Response: $content")
    }
}
```

**Java Example:**

```java
import android.content.Intent;
import android.util.Base64;
import org.json.JSONObject;

public void callPosSystemAPI(String method, String path, JSONObject headers, String body) {
    try {
        // Base64URL encode headers
        String headersJson = headers.toString();
        byte[] headerBytes = headersJson.getBytes("UTF-8");
        String headerB64 = Base64.encodeToString(headerBytes, 
            Base64.URL_SAFE | Base64.NO_PADDING | Base64.NO_WRAP);
        
        // Base64URL encode body
        String bodyB64 = null;
        if (body != null) {
            byte[] bodyBytes = body.getBytes("UTF-8");
            bodyB64 = Base64.encodeToString(bodyBytes, 
                Base64.URL_SAFE | Base64.NO_PADDING | Base64.NO_WRAP);
        }
        
        // Create intent
        Intent intent = new Intent();
        intent.setClassName("eu.fiskaltrust.androidlauncher", 
            "eu.fiskaltrust.androidlauncher.PosSystemAPI");
        intent.putExtra("Method", method);
        intent.putExtra("Path", path);
        intent.putExtra("HeaderJsonObjectBase64Url", headerB64);
        if (bodyB64 != null) {
            intent.putExtra("BodyBase64Url", bodyB64);
        }
        
        startActivityForResult(intent, REQUEST_CODE);
    } catch (Exception e) {
        Log.e("PosSystemAPI", "Error creating intent", e);
    }
}

@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    
    if (requestCode == REQUEST_CODE && data != null) {
        String statusCode = data.getStringExtra("StatusCode");
        String contentB64 = data.getStringExtra("ContentBase64Url");
        String contentTypeB64 = data.getStringExtra("ContentTypeBase64Url");
        
        try {
            // Decode Base64URL
            byte[] contentBytes = Base64.decode(contentB64, 
                Base64.URL_SAFE | Base64.NO_PADDING | Base64.NO_WRAP);
            String content = new String(contentBytes, "UTF-8");
            
            byte[] typeBytes = Base64.decode(contentTypeB64, 
                Base64.URL_SAFE | Base64.NO_PADDING | Base64.NO_WRAP);
            String contentType = new String(typeBytes, "UTF-8");
            
            Log.i("PosSystemAPI", "Status: " + statusCode + ", Type: " + contentType);
            Log.i("PosSystemAPI", "Response: " + content);
        } catch (Exception e) {
            Log.e("PosSystemAPI", "Error decoding response", e);
        }
    }
}
```

**C#/MAUI Example:**

```csharp
#if ANDROID
using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using System;
using System.Text;
using Newtonsoft.Json;

public class PosSystemApiActivityCaller : Activity
{
    private const int RequestCode = 1001;

    public void CallPosSystemAPI(string method, string path, object headers, string body)
    {
        // Serialize headers to JSON
        var headersJson = JsonConvert.SerializeObject(headers);
        
        // Base64URL encode
        var headerB64 = ToBase64Url(headersJson);
        var bodyB64 = body != null ? ToBase64Url(body) : null;
        
        // Create intent
        var intent = new Intent();
        intent.SetClassName("eu.fiskaltrust.androidlauncher", 
            "eu.fiskaltrust.androidlauncher.PosSystemAPI");
        intent.PutExtra("Method", method);
        intent.PutExtra("Path", path);
        intent.PutExtra("HeaderJsonObjectBase64Url", headerB64);
        if (bodyB64 != null)
        {
            intent.PutExtra("BodyBase64Url", bodyB64);
        }
        
        StartActivityForResult(intent, RequestCode);
    }
    
    private string ToBase64Url(string text)
    {
        var bytes = Encoding.UTF8.GetBytes(text);
        return Convert.ToBase64String(bytes)
            .TrimEnd('=')
            .Replace('+', '-')
            .Replace('/', '_');
    }
    
    private string FromBase64Url(string base64Url)
    {
        var base64 = base64Url
            .Replace('-', '+')
            .Replace('_', '/');
        
        // Add padding if needed
        switch (base64.Length % 4)
        {
            case 2: base64 += "=="; break;
            case 3: base64 += "="; break;
        }
        
        var bytes = Convert.FromBase64String(base64);
        return Encoding.UTF8.GetString(bytes);
    }
    
    // Example: Echo call
    public void EchoExample()
    {
        var headers = new Dictionary<string, string>
        {
            { "Accept", "application/json" },
            { "x-cashbox-id", "de12c75f-5587-48b8-8ac5-64b7c81a05ec" },
            { "x-cashbox-accesstoken", "your-access-token" },
            { "x-operation-id", Guid.NewGuid().ToString() }
        };
        var body = JsonConvert.SerializeObject(new { Message = "Hello, World!" });
        
        CallPosSystemAPI("POST", "/echo", headers, body);
    }

    protected override void OnActivityResult(int requestCode, [GeneratedEnum] Result resultCode, Intent data)
    {
        base.OnActivityResult(requestCode, resultCode, data);
        
        if (requestCode == RequestCode && data != null)
        {
            var statusCode = data.GetStringExtra("StatusCode") ?? "500";
            var contentB64 = data.GetStringExtra("ContentBase64Url") ?? "";
            var contentTypeB64 = data.GetStringExtra("ContentTypeBase64Url") ?? "";
            
            // Decode Base64URL
            var content = FromBase64Url(contentB64);
            var contentType = FromBase64Url(contentTypeB64);
            
            Android.Util.Log.Info("PosSystemAPI", $"Status: {statusCode}, Type: {contentType}");
            Android.Util.Log.Info("PosSystemAPI", $"Response: {content}");
        }
    }
}
#endif
```

### Response Structure

The middleware responds via a result intent with these extras:

| Extra Key | Type | Description |
|-----------|------|-------------|
| `StatusCode` | String | HTTP status code as string (e.g., "200", "201", "400", "500") |
| `ContentBase64Url` | String | Base64URL-encoded response body |
| `ContentTypeBase64Url` | String | Base64URL-encoded content type (e.g., "application/json") |
| `HeaderJsonObjectBase64Url` | String | Base64URL-encoded JSON headers object (optional, for response headers) |

## Available Endpoints

### 1. Echo - Connectivity Testing

**Purpose**: Test basic communication with the middleware and verify configuration.

**Endpoint**: `/echo`

**Scenario**: Used to verify that the POS system can communicate with the middleware before performing fiscal operations.

### 2. Sign - Receipt Fiscalization

**Purpose**: Fiscalize receipts by sending them to the fiscal middleware for signing and compliance.

**Endpoint**: `/sign`

**Scenario**: Used after completing a transaction to ensure fiscal compliance by signing the receipt data.

### 3. Pay - Payment Processing

**Purpose**: Process payments through integrated payment providers (PayPal, Viva, BlueCode, Hobex, etc.).

**Endpoint**: `/pay`

**Scenario**: Initiate payment processing with external payment terminals or providers.

### 4. Cart - Shopping Cart Management

**Purpose**: Manage shopping carts for customer journeys across multiple steps.

**Endpoints**: 
- `POST /v2/cart` - Create new cart
- `GET /v2/cart` - Get active cart
- `GET /v2/cart/{journeyId}` - Get specific cart
- `PUT /v2/cart/{journeyId}` - Update cart
- `DELETE /v2/cart/{journeyId}` - Delete cart
- `POST /v2/cart/{journeyId}/setdone` - Mark cart as done
- `PUT /v2/cart/{journeyId}/deliverymethod` - Set delivery method
- `POST /v2/cart/{journeyId}/authorize` - Authorize cart

**Scenario**: Track customer purchases across multiple interactions, especially useful for table service or order-ahead scenarios.

### 5. Order - Order Item Management

**Purpose**: Add charge items to a cart/journey.

**Endpoint**: `/order`

**Scenario**: Add items to an existing cart during the customer's shopping journey.

### 6. Issue - Receipt Issuance

**Purpose**: Issue/print receipts and make them available for customer retrieval.

**Endpoints**:
- `PUT /v2/issue/{queueId}/{queueItemId}` - Issue receipt
- `GET /v2/issue/{queueId}/{queueItemId}` - Get issued receipt
- `GET /v2/issue/{queueId}/{queueItemId}/delivered` - Mark as delivered
- `GET /v2/issue/{queueId}/{queueItemId}/link/qrcode` - Get QR code link

**Scenario**: After fiscalizing a receipt, make it available to the customer via digital channels.

### 7. Journal - Transaction Logging

**Purpose**: Query the fiscal journal for auditing and reporting.

**Endpoints**:
- `POST /v2/journal` - Query journal entries
- `GET /v2/journal/OperationItem/{operationId}` - Get specific operation
- `GET /v2/PeekJournalItem/{queueId}/OperationItem/{operationId}` - Peek at operation
- `GET /v2/PeekJournalItem/{queueId}/OperationItem` - List operations

**Scenario**: Retrieve historical transaction data for reporting or compliance purposes.

## Error Handling

### HTTP Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Existing operation retrieved successfully |
| 201 | Created | New operation created and processed successfully |
| 400 | Bad Request | Invalid request data or validation error |
| 401 | Unauthorized | Invalid or missing access token |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Operation ID conflict (duplicate with different payload) |
| 500 | Internal Server Error | Processing error |
| 502 | Bad Gateway | Middleware communication error |

### Error Response Structure

```json
{
    "type": "https://tools.ietf.org/html/rfc9110#section-15.5.1",
    "title": "Validation Error",
    "status": 400,
    "detail": "cbReceiptMoment is required",
    "errors": {
        "cbReceiptMoment": ["The cbReceiptMoment field is required."]
    }
}
```

## Integration Steps for Android Applications

### 1. Add Permissions to AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.pos">
    
    <!-- Required for network operations (if online mode needed) -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Required for intent communication -->
    <queries>
        <package android:name="eu.fiskaltrust.androidlauncher" />
    </queries>
    
</manifest>
```

### 2. Verify Middleware Installation

```kotlin
fun isMiddlewareInstalled(context: Context): Boolean {
    val intent = Intent("eu.fiskaltrust.androidlauncher.POSSYSTEMAPI")
    intent.addCategory(Intent.CATEGORY_DEFAULT)
    val resolveInfo = context.packageManager.resolveActivity(
        intent, 
        PackageManager.MATCH_DEFAULT_ONLY
    )
    return resolveInfo != null
}
```

## Limitations and Requirements

### Requirements

1. **fiskaltrust.Middleware**: The middleware application must be installed and running on the Android device
2. **Configuration**: Middleware must be properly configured with valid cashbox ID and access token
3. **Android Version**: Minimum Android 8.0 (API level 26) recommended
4. **Permissions**: App must have appropriate permissions to send intents
5. **Internet**: Initial setup and some operations may require internet connectivity

### Limitations

1. **Offline Mode**: Full offline capability depends on middleware configuration and market requirements
2. **Payment Providers**: Not all payment providers support offline operation
3. **Queue Capacity**: Limited storage capacity for offline transactions on the device
4. **Synchronization**: Offline transactions must be synchronized when connectivity is restored
5. **Market-Specific**: Some features are only available in specific markets (e.g., Viva payments in Greece)

### Best Practices

1. **Operation IDs**: Always use unique GUIDs for operation IDs to ensure idempotency
2. **Error Handling**: Implement robust error handling and retry logic
3. **State Monitoring**: For long operations, use async mode and poll state regularly
4. **Timeout Handling**: Set appropriate timeouts and handle timeout scenarios
5. **Network Detection**: Check network availability and switch between online/offline modes accordingly
6. **Data Validation**: Validate request data before sending to avoid unnecessary errors
7. **Secure Storage**: Store access tokens and sensitive data securely
8. **Testing**: Thoroughly test both online and offline scenarios

## Testing and Development

### Local Testing

For development and testing purposes, you can use localhost mode:

```kotlin
// Use the callPosSystemAPI() helper function shown in the Complete Intent Call Example section above""")
}
```

### Sandbox Environment

Use sandbox credentials for testing:

```kotlin
const val SANDBOX_CASHBOX_ID = "sandbox-cashbox-id"
const val SANDBOX_ACCESS_TOKEN = "sandbox-access-token"
```

### Mock Responses

For unit testing without middleware:

```kotlin
class MockMiddlewareClient {
    fun signReceipt(request: ReceiptRequest): ReceiptResponse {
        return ReceiptResponse(
            ftCashBoxID = request.ftCashBoxID,
            ftQueueID = UUID.randomUUID(),
            ftQueueItemID = UUID.randomUUID(),
            // ... mock response fields
        )
    }
}
```
