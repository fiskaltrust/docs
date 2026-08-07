---
slug: /posdealers/technical-operations/middleware/localpossystemapi-helper
title: Local PosSystem API Helper
---
# Configuring the Local PosSystem API Helper with Launcher 2.0

:::caution

The LocalPosSystemApi Helper is currently in preview.

:::

:::info summary

After reading this, you can set up and configure the LocalPosSystemApi Helper within a Launcher 2.0 deployment.

:::

## Introduction

The LocalPosSystemApi Helper is a Middleware component that exposes a local endpoint through which the POS System communicates with the fiskaltrust Middleware.
It acts as a bridge between the POS System and the underlying Queue.

:::caution

The LocalPosSystemApi Helper must be part of the **same [CashBox](../middleware/cashbox.md)** as the Queue it is intended to serve.

:::

:::caution

As the LocalPosSystemApi Helper is currently only supported on the Launcher 2.0 this setup does not work for France.
Refer to the [guide on how to setup the LocalPosSystemApi helper for the Middleware 1.2](./localpossystemapi-helper-1-2.md).

If you're interested in running this in Austria reach out to us as the launcher 2.0 is not enabled per default there.

:::

## Add a LocalPosSystemApi Helper

To add the LocalPosSystemApi Helper, navigate to `Configuration` / `Helper` in the fiskaltrust Portal and follow the steps below.
Note that the following figures and steps are exemplary.

![possystemapihelper1.png](images/possystemapihelper1.png)

*Figure 1. Helper configuration page in the fiskaltrust Portal where a LocalPosSystemApi Helper is added; steps are listed in Table 1.*

| Steps | Description |
|-------|-------------|
| ![Number 1](../../images/numbers/circle-1o.png) | Navigate to `Configuration`/ `Helper` to get to the Helper configuration. |
| ![Number 2](../../images/numbers/circle-2o.png) | Click `+Add` to create a new Helper. |
| ![Number 3](../../images/numbers/circle-3o.png) | Add or edit a **name** for your Helper at `Description`. |
| ![Number 4](../../images/numbers/circle-4o.png) | Select `fiskaltrust.Middleware.Helper.LocalPosSystemApi` from the **`Package name`** drop-down list. Note that this selection **cannot be changed later**. |
| ![Number 5](../../images/numbers/circle-5o.png) | Select the latest `Package version` using the drop-down list. |
| ![Number 6](../../images/numbers/circle-6o.png) | You can select one of the available outlets with the drop-down list. |
| ![Number 7](../../images/numbers/circle-7o.png) | Click `Save` to save your changes. |

*Table 1. Steps to add a LocalPosSystemApi Helper in the fiskaltrust Portal, as shown in Figure 1.*

After the Helper has been saved, a **success** notification confirms that it has been created. The configuration window for the new Helper then opens automatically, allowing you to proceed with the configuration.

## Configure a LocalPosSystemApi Helper

![posystemapiconfiguration.png](images/posystemapiconfiguration.png)

*Figure 2. Configuration window of the new LocalPosSystemApi Helper; steps are listed in Table 2.*

| Steps | Description |
|-------|-------------|
| ![Number 1](../../images/numbers/circle-1o.png) | Click `http` to generate a URL that the POS system can use to access the Helper. You can also rename the URL if desired. |
| ![Number 2](../../images/numbers/circle-2o.png) | Click `Save` to save your changes and return to `Configuration`/ `Helper`. |

*Table 2. Steps to configure the LocalPosSystemApi Helper and generate its URL, as shown in Figure 2.*

## Use a LocalPosSystemApi Helper

![assignposysstemapi.png](images/assignposysstemapi.png)

*Figure 3. CashBox search on the `Configuration` / `CashBox` page in the fiskaltrust Portal; steps are listed in Table 3.*

| Steps | Description |
|-------|-------------|
| ![Number 1](../../images/numbers/circle-1o.png) | Navigate to `Configuration` / `CashBox` and search for the desired CashBox. |
| ![Number 2](../../images/numbers/circle-2o.png) | Click `Edit` to open the CashBox configuration. |

*Table 3. Steps to locate and open the desired CashBox configuration, as shown in Figure 3.*

![selecthelper.png](images/selecthelper.png)

*Figure 4. Helpers section of the CashBox configuration; steps are listed in Table 4.*

| Steps | Description |
|-------|-------------|
| ![Number 3](../../images/numbers/circle-3o.png) | Scroll down to the **Helpers** section and locate the LocalPosSystemApi Helper. |
| ![Number 4](../../images/numbers/circle-4o.png) | Activate the Helper by selecting its checkbox. |

*Table 4. Steps to activate the LocalPosSystemApi Helper in the CashBox, as shown in Figure 4.*

![savecashboxconfig.png](images/savecashboxconfig.png)

*Figure 5. Saving the CashBox configuration after activating the Helper; steps are listed in Table 5.*

:::info

The same LocalPosSystemApi Helper can be used in multiple cashboxes.

:::

| Steps | Description |
|-------|-------------|
| ![Number 5](../../images/numbers/circle-5o.png) | Scroll back to the top of the page. |
| ![Number 6](../../images/numbers/circle-6o.png) | Click `Save` to sabe your configuration. |

*Table 5. Steps to save the CashBox configuration, as shown in Figure 5.*

## Download Launcher

:::caution

The minimum required Launcher version is **2.0.0-rc.25**. When downloading a launcher the latest version is downloaded automatically.

:::

![downloadlauncher.png](images/downloadlauncher.png)

*Figure 6. `Configuration` / `CashBox` page showing the configured Helper URL and Launcher download; steps are listed in Table 6.*

| Steps | Description |
|-------|-------------|
| ![Number 1](../../images/numbers/circle-1o.png) | Return to the `Configuration` / `CashBox` page. You should see the Helper URL configured in the previous step. |
| ![Number 2](../../images/numbers/circle-2o.png) | Click `Rebuild configuration` and wait for the success confirmation. |
| ![Number 3](../../images/numbers/circle-3o.png) | Click `Download` and select the appropriate Version 2 Launcher architecture for your system. |

*Table 6. Steps to rebuild the configuration and download the Launcher 2.0, as shown in Figure 6.*

## Deploy the CashBox

Once the Launcher package is downloaded, extract it and run `launcher-test.cmd` (or `launcher-test.sh` on unix based systems) to start the Middleware. For detailed instructions on starting the Launcher and installing it as a service, see [Launcher 2.0 Getting Started](https://github.com/fiskaltrust/middleware-launcher?tab=readme-ov-file#getting-started).

## Test the LocalPosSystemApi Helper

Once the Middleware is running, verify that the LocalPosSystemApi Helper is working correctly by sending a test request. The easiest way to do this is by using the [fiskaltrust Developer Portal](https://developer.fiskaltrust.eu/), which provides an interactive interface for sending requests to the Middleware and inspecting the responses.

![fiskaltrustfordevpage.png](images/fiskaltrustfordevpage.png)

*Figure 7. Landing page of the fiskaltrust Developer Portal listing the available APIs.*

Select **POS System API** from the available options.

![fiskaltrustfordev_selectmarket.png](images/fiskaltrustfordev_selectmarket.png)

*Figure 8. Market selection in the POS System API view of the Developer Portal.*

Select your market.

![fiskaltrustfordev_settings.png](images/fiskaltrustfordev_settings.png)

*Figure 9. Settings button in the top-right corner of the Developer Portal.*

Click **Settings** in the top-right corner.

![fiskaltrustfordev_setsettings.png](images/fiskaltrustfordev_setsettings.png)

*Figure 10. Settings dialog for pointing the Developer Portal at the local Middleware; steps are listed in Table 7.*

| Steps | Description |
|-------|-------------|
| ![Number 1](../../images/numbers/circle-1o.png) | In the `Environment` section, select `Local Middleware`. |
| ![Number 2](../../images/numbers/circle-2o.png) | In the `Middleware Endpoint` field, enter the Helper URL found on the `Configuration` / `CashBox` page. |
| ![Number 3](../../images/numbers/circle-3o.png) | Copy the PIN from the `Configuration` / `CashBox` page, enter it in the field below, then click `Pair`. A confirmation message should appear as shown below. |

*Table 7. Steps to configure the local Middleware endpoint and pair the Developer Portal, as shown in Figure 10.*

![pairedpin.png](images/pairedpin.png)

*Figure 11. Confirmation message shown after successfully pairing with the local Middleware; steps are listed in Table 8.*

| Steps | Description |
|-------|-------------|
| ![Number 4](../../images/numbers/circle-4o.png) | The **CashBox ID** and **Access Token** fields are populated automatically. |
| ![Number 5](../../images/numbers/circle-5o.png) | Click `Test Connection` — a green **201** response confirms that the Helper is working correctly. |

*Table 8. Steps to verify the connection to the local Middleware, as shown in Figure 11.*

Close **Settings**. You can now use the available endpoints to send requests to the Middleware and verify the Helper functionality.

![fiskaltrustfordev_endpoints.png](images/fiskaltrustfordev_endpoints.png)

*Figure 12. Available POS System API endpoints in the Developer Portal for sending requests to the Middleware.*
