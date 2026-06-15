---
slug: /poscreators/middleware-doc/instore-app/available-settings
title: Available Settings
---

# Available Settings - InStore App

:::info Important

All settings and options described here apply to version the release **1.3.1** of the InStore App.  
If you are using an older version, some settings may differ or may not be available at all.

:::

---

## Main settings

### Operation Mode
Defines which features are available in the UI. Some options and sections appear or hide based on this selection:

- **Consumer** – Customer-facing (receipt display/printing). Allows changing **Print Delay**, which is not available in Merchant mode.
- **Merchant** – Merchant/admin. Cannot change Print Delay, but offers extra gestures:  
  - Pull **down** on the QR code screen to show the receipt.  
  - Pull **up** to reveal action buttons.

:::info Note

As merchante mode is usually used in an environment where the InStore App is not the main application used on the host device, selecting **Merchant** mode automatically enables **Enable running in Background**.

:::

### Terminal ID Filter
Filters receipts and data for a specific terminal within the CashBox.  
For advanced multi-terminal options, see [Multiterminal Settings](https://docs.fiskaltrust.eu/docs/poscreators/middleware-doc/instore-app/multiterminal-settings)

### Enable running in Background
Runs the app as an **Android foreground service** also displaying a notification in the Android status bar (when notifications are enabled in Android settings) that shows "InStore App is running in the background". The service takes care that the app is run at all times.

When enabled it results in the following behaviour:
- Even if the InStore App is not in foreground (e.g., the user is working with the POS app on the same device), it continues to run in the background.
- The InStore App **auto‑starts after device boot** so no manual start is required after boot. This means even without ever starting the InStore App manually it will start in the background automatically and can process actions (like trigger payments or show receipts).

:::info Note

This setting is **mandatory for Android 15+**.

:::

### Use local configuration

If enabled, local device settings override the backend configuration.

If disabled, the app follows centrally managed (backend) settings.

Once the setting is disabled and the app is restarted, the configuration stored in the backend will be loaded into the app.

This configuration can be applied:
- **Per device**: A specific configuration for each individual device.
- **Per cashbox**: A shared configuration for all devices connected to a particular cashbox.

---

## Printer settings

Tapping **Printer** opens a sub-page where you can select a printer; the remaining print options configuration necesary, if any, appear once a real printer is selected.

#### Printer
Shows all available printers (USB, Bluetooth, ESC POS Network printing, ... ). Select the one you want to use.
Some payment terminals also expose an integrated printer and are tied to the payment configuration (e.g. the Shift4 Commerce Engine printer). Such printers might only appear after the payment provider was configured. Therefore we suggest to first configure Payment and afterwards the printer.

#### Print Delay
Defines the delay before an issued receipt will get printed automatically if the guest/customer is not receiving the receipt in another way like scanning the QR code with their phone, just accepting it by pressing OK or another method.

Default: 30s.
**Available only in Consumer mode.**

#### Paper width
Set the receipt width: **48 mm**, **72 mm**, or **80 mm**.

#### IP Address / IP Port
Shown only when **ESC POS Network printing** is selected. Enter the printer's network **IP Address** and **IP Port** (default port **9100**).

#### Print Demo
Executes a simple "demo" test print to check basic printer functionality.

---

## Payment settings

Tapping **Payment Method** opens a sub-page where you select and configure a payment provider.

#### Payment Method
Select the payment provider to use on this device (e.g., **Hobex ECR**, **Hobex POSit**, **Softpay.io**, **WPI SoftPay**, **Viva Wallet**, **GP tom**, **GP Pay**, **Shift4**). 
After selection, provider‑specific options appear as needed.

##### Use Sandbox app *(internal / sandbox builds only)*
For **Softpay.io**, **Hobex POSit**, and **GPTom** (and maybe others in future) show a **Use Sandbox app** switch. When enabled, the provider's sandbox app is used instead of the production app.
This switch is only available when the InStore App is paired to a sandbox cashbox.

##### HobexECR
- **Terminal ID** – The terminal ID assigned by Hobex.
- **Password** – The password for ECR integration (tap the eye icon to reveal/hide it).
- **Host** – Hostname or IP of the ECR endpoint (default `localhost`).
- **Port** – TCP port of the ECR endpoint (default `9990`).

##### Shift4

- **Auth Token** – The merchant auth token which will be provided by the merchant's Lighthouse Transaction Manager Account Administrator. The expected format is `12345678-ABCD-1234-ABCD1234567890EF` (uppercase hex); an inline message is shown if the format is invalid. For further help please refer to Shift4 support.
- **Commerce Engine Host** – The Commerce Engine host address to connect to and process payment requests. If not otherwise provided by fiskaltrust support please use *127.0.0.1:8085*.
- **Allow API Debugging** – Allows insecure certificates for troubleshooting. **Do not use in production.**

#### Test Communication
Available for some payment solutions only. Checks connectivity with the configured payment endpoint before going live.

---

## Other

### Advanced

Tapping **Advanced** opens a sub-page with the following options:

#### Enable webview URL
When enabled, the website represented by the configured URL is shown on the home screen (the idle "no active session" view) instead of the default screen. Enter a valid `http://` or `https://` URL in the field that appears. While the toggle is on but the field is empty or the URL is invalid, the app keeps showing the default home screen and displays an inline warning.

#### Lock settings via PIN
When enabled, opening the **Settings** page requires a 6‑digit PIN. This prevents unwanted configuration changes (e.g. by waiters).

- When you enable the lock, the app shows the **PIN once** so you can note it down.
- Disabling the lock also requires entering the PIN.
- After **5 wrong attempts within one hour**, PIN entry is locked for up to an hour.

#### Unpair CashBox
Disconnects the current CashBox to pair another one (e.g., when moving the device to a new store).

#### Quit App
Closes the app gracefully after a confirmation prompt and persists configuration changes.  
It also stops the background service, so **Enable running in Background** is no longer active until the app is started again.  
*Note:* Closing during an active process (e.g., printing) may interrupt that process — finish ongoing tasks first.

### About

Tapping **About** opens a sub-page showing device and app information. *(All fields are read‑only.)*

- **IP Address** – The current IP address of the device on your network. Use it when setting up network printing or firewall rules. Only appears when the device is connected via **LAN/WLAN**; hidden when using mobile data.
- **Device Type** – The device model/type (e.g., terminal vendor and model). Useful to identify hardware-specific behavior.
- **Device ID** – The unique identifier of this device. Quote this ID when contacting support or managing a fleet. Tap it to show the full ID in a popup.
- **CashBox ID** – The CashBox the app is paired with (shows **"Not paired"** when no CashBox is paired). Tap it to show the full ID in a popup.
- **Support contact** – Displays the fiskaltrust support email address.
- **Version** – The currently installed app version.

---

## Best practices

- Keep **Use local configuration** **off** if you manage settings centrally — this prevents drift from backend policies.
- Use **Test Communication** before going live when available.
