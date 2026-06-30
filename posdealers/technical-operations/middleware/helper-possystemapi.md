---
slug: /posdealers/technical-operations/middleware/helper-possystemapi
title: Local PosSystem API Helper
---
# How to Configure the Local PosSystem API Helper with Launcher 2.0

:::caution

The local PosSystem API Helper is currently in preview.

:::

:::info summary

After reading this, you can set up and configure the local PosSystem API Helper within a Launcher 2.0 deployment.

## Introduction

The local PosSystem API Helper is a Middleware component that exposes a local endpoint through which the POS System communicates with the fiskaltrust Middleware. It acts as a bridge between the POS System and the underlying Queue, and is required for Launcher 2.0 deployments.

:::caution

The PosSystem API Helper must be part of the **same [CashBox](cashbox.md)** as the Queue it is intended to serve.

:::

:::caution

As the local PosSystem API Helper is currently only supported on the Launcher 2.0 this setup does not work for France. If you're interested in running this in Austria reach out to us as the launcher 2.0 is not enabled per default there.

:::
## Add a Helper Local PosSystem API

To add the local PosSystem API Helper, navigate to `Configuration` / `Helper` in the fiskaltrust Portal and follow the steps below. 
Note that the following figures and steps are exemplary.

![possystemapihelper1.png](images/possystemapihelper1.png)

| steps | description                                                                                                                                 |
|:----------------------:|---------------------------------------------------------------------------------------------------------------------------------------------|
|![Number 1](../../images/numbers/circle-1o.png) | _Choose `Configuration`/ `Helper` to get to the Helper configuration._                                                                      |
|![Number 2](../../images/numbers/circle-2o.png) | _Click on `+Add` for creating a new Helper._                                                                                                |
|![Number 3](../../images/numbers/circle-3o.png) | Add or edit a **name** for your Helper at  `Description`.                                                                                   |
|![Number 4](../../images/numbers/circle-4o.png) | Select `fiskaltrust.Middleware.Helper.LocalPosSystemApi` from the **`Package name`** drop-down. Note that this selection **cannot be changed later**. |
|![Number 5](../../images/numbers/circle-5o.png) | Select the latest `Package version` using the drop-down menu.                                                                                      |
|![Number 6](../../images/numbers/circle-6o.png) | You can select one of the available outlets with the drop-down menu.                                                                        |
|![Number 7](../../images/numbers/circle-7o.png) | `Save` your changes.                                                                                                                        |

Once saved, a **success** notification will appear confirming that the Helper has been created. The configuration window for the new Helper will then open automatically, allowing you to proceed with the setup.

## Configure a PosSystem API Helper
![posystemapiconfiguration.png](images/posystemapiconfiguration.png)

| steps | description                                                                                                                                 |
|:----------------------:|---------------------------------------------------------------------------------------------------------------------------------------------|
|![Number 1](../../images/numbers/circle-1o.png) | Click `http` to generate a URL through which the POS-System can access the Helper. You may also rename the URL to one of your own choosing.                                                                |
|![Number 2](../../images/numbers/circle-2o.png) | `Save` your changes to return to `Configuration`/ `Helper`.                                                                                            |


:::info

Note down the URL you configured for the PosSystem API Helper as you will use it to connect to the cashbox.

:::

## Use a PosSystem API Helper

![assignposysstemapi.png](images/assignposysstemapi.png)

|                     steps                      | description                                                                            |
|:----------------------------------------------:|----------------------------------------------------------------------------------------|
|![Number 1](../../images/numbers/circle-1o.png) | Navigate to `Configuration` / `CashBox` and search for the desired CashBox. |
|![Number 2](../../images/numbers/circle-2o.png) | Click `Edit` to open the CashBox configuration. |

![selecthelper.png](images/selecthelper.png)

|                      steps                      | description                             |
|:-----------------------------------------------:|-----------------------------------------|
| ![Number 3](../../images/numbers/circle-3o.png) | Scroll down to the **Helpers** section and locate the PosSystem API Helper. |
| ![Number 4](../../images/numbers/circle-4o.png) | Activate the Helper by selecting its checkbox. |

![savecashboxconfig.png](images/savecashboxconfig.png)

:::info

The same LocalPosSystemApi Helper can be used in multiple cashboxes.

:::

|                      steps                      | description |
|:-----------------------------------------------:|-----------|
| ![Number 5](../../images/numbers/circle-5o.png) | Scroll back to the top of the page. |
| ![Number 6](../../images/numbers/circle-6o.png) | `Save` your configuration. |

## Download Launcher

:::caution

The minimum required Launcher version is **2.0.0-rc.25**. When downloading a launcher the latest version is automatically downloaded.

:::

![downloadlauncher.png](images/downloadlauncher.png)

| steps | description |
|:----------------------:|-------------|
|![Number 1](../../images/numbers/circle-1o.png) | Return to the `Configuration` / `CashBox` page. You should see the Helper URL you configured in the previous step. |
|![Number 2](../../images/numbers/circle-2o.png) | Click `Rebuild configuration` and wait for the success confirmation. |
|![Number 3](../../images/numbers/circle-3o.png) | Click `Download` and select the correct Version 2 Launcher architecture for your system. |

## Deploy the CashBox

Once the Launcher package is downloaded, extract it and run `launcher-test.cmd` (or `launcher-test.sh` on unix based systems) to start the Middleware. For detailed instructions on starting the Launcher and installing it as a service, see [Launcher 2.0 Getting Started](https://github.com/fiskaltrust/middleware-launcher?tab=readme-ov-file#getting-started).

## Test the PosSystem API Helper

Once the Middleware is running, verify that the PosSystem API Helper is working correctly by sending a test request. The easiest way to do this is to use the [fiskaltrust Developer Portal](https://developer.fiskaltrust.eu/), which provides an interactive interface for sending requests to the Middleware and inspecting the responses.

![fiskaltrustfordevpage.png](images/fiskaltrustfordevpage.png)

Select **POS System API** from the available options.

![fiskaltrustfordev_selectmarket.png](images/fiskaltrustfordev_selectmarket.png)

Select your market.

![fiskaltrustfordev_settings.png](images/fiskaltrustfordev_settings.png)

Click **Settings** in the top-right corner.

![fiskaltrustfordev_setsettings.png](images/fiskaltrustfordev_setsettings.png)

| steps | description                                                                                                                                                              |
|:----------------------:|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|![Number 1](../../images/numbers/circle-1o.png) | In the `Environment` section, select `Local Middleware`.                                                                                                                 |
|![Number 2](../../images/numbers/circle-2o.png) | In the `Middleware Endpoint` field, enter the **Helper URL** of the LocalPosSystemApi Helper found on the `Configuration` / `CashBox` page.                                                                  |
|![Number 3](../../images/numbers/circle-3o.png) | Copy the PIN from the `Configuration` / `CashBox` page, enter it in the field below, then click `Pair`. A confirmation message should appear as shown below. |

![pairedpin.png](images/pairedpin.png)

|                      steps                      | description                                                             |
|:-----------------------------------------------:|-------------------------------------------------------------------------|
| ![Number 4](../../images/numbers/circle-4o.png) | The `CashBox ID` and `Access Token` fields will be populated automatically. |
| ![Number 5](../../images/numbers/circle-5o.png) | Click `Test Connection` — a green **201** response confirms the Helper is working correctly. |

Close **Settings**. You can now use the available endpoints to send requests to the Middleware and verify the Helper's functionality.

![fiskaltrustfordev_endpoints.png](images/fiskaltrustfordev_endpoints.png)
