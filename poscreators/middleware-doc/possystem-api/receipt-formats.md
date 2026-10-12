---
slug: /poscreators/possystem-api/receipt-formats
title: Receipt Formats
---

# Receipt Formats

## Overview

After a receipt has been issued via `POST /issue`, the POS system can retrieve the rendered receipt in different formats with `GET /issue/{QueueId}/{QueueItemId}`. The `QueueId` and `QueueItemId` are the `ftQueueID` and `ftQueueItemID` returned in the `/issue` response. Retrieving the receipt this way does not update its submitted/viewed state.

The format is selected via the standard HTTP `Accept` header. The caller should always set this header explicitly. Authentication works the same as for every other endpoint (see [Request Headers](./introduction.md#request-headers)).

For the full request/response models, see the [POS System API reference (v2.1)](https://docs.fiskaltrust.eu/apis/pos-system-api).

## Available formats

| `Accept` value                                                            | Output                                    | Rendering width                                           |
|---------------------------------------------------------------------------|-------------------------------------------|-----------------------------------------------------------|
| `image/png`                                                               | PNG image, rasterized at 8 dots/mm (203 dpi) | `;width=NNmm` parameter or `x-print-width` request header |
| `application/pdf`                                                         | PDF document                              | –                                                         |
| `application/json`                                                        | JSON                                      | –                                                         |
| `text/vnd.esc-pos;charset=utf-8`                                          | ESC/POS printer commands                  | `;width=NNmm` parameter                                   |
| `application/esc-pos-80mm`, `application/esc-pos-72mm`, `application/esc-pos-48mm` | ESC/POS printer commands (**deprecated**) | Fixed by the media type                                   |

*Table 1. Supported `Accept` values for `GET /issue/{QueueId}/{QueueItemId}`.*

:::warning

The `application/esc-pos-*` media types are deprecated legacy aliases for `text/vnd.esc-pos;charset=utf-8;width=NNmm`. Use `text/vnd.esc-pos` in new integrations.

:::

The `Accept` header may contain a list of media ranges with fallbacks, for example `image/png;width=48mm, */*;q=0.1`. The most-preferred concrete media range is used.

## Rendering width

For PNG and ESC/POS output, the POS system can specify the rendering width that matches its printer:

- As a `width` media-type parameter on the `Accept` value, for example `image/png;width=48mm` or `text/vnd.esc-pos;charset=utf-8;width=72mm`.
- For `image/*` types, alternatively via the `x-print-width` request header, for example `x-print-width: 48mm`. If the `Accept` value also contains a `width` parameter, the media-type parameter takes precedence.

The value is the **printable width** in millimeters, not the paper width. For example, a 58mm thermal printer has a printable width of 48mm. Common values are `48mm`, `58mm`, `72mm` and `80mm` (pattern `^\d{2,3}mm$`).

| Format  | Effect of the width                                                                                                   |
|---------|-----------------------------------------------------------------------------------------------------------------------|
| PNG     | Image width at 8 dots/mm. For example, `width=48mm` returns a 384px-wide image that maps 1:1 onto a 58mm thermal print head. |
| ESC/POS | Column layout: 48 columns for `80mm` and wider, 42 columns for `72mm`–`79mm`, 32 columns below `72mm`.                |

*Table 2. Effect of the rendering width per output format.*

If no width is specified, the receipt is rendered at the default width of 80mm. Malformed or unknown `width` values are ignored and the default 80mm rendering is returned; unknown parameters never cause an error.

The response returns the width that was **actually applied** in the `x-print-width` response header. For example, a request for `74mm` is rendered with the 72mm/42-column layout and returns `x-print-width: 72mm`. ESC/POS responses additionally carry the width on the `Content-Type` (`text/vnd.esc-pos; charset=utf-8; width=80mm`), while `image/*` responses keep a `Content-Type` without parameters.

## Examples

Retrieve the receipt as PNG for a 58mm thermal printer:

```http
GET /issue/{QueueId}/{QueueItemId}
x-cashbox-id: <cashbox-id>
x-cashbox-accesstoken: <access-token>
Accept: image/png;width=48mm
```

Retrieve the receipt as ESC/POS commands for an 80mm printer:

```http
GET /issue/{QueueId}/{QueueItemId}
x-cashbox-id: <cashbox-id>
x-cashbox-accesstoken: <access-token>
Accept: text/vnd.esc-pos;charset=utf-8;width=80mm
```

Retrieve the receipt as PDF:

```http
GET /issue/{QueueId}/{QueueItemId}
x-cashbox-id: <cashbox-id>
x-cashbox-accesstoken: <access-token>
Accept: application/pdf
```
