module.exports = [
  "posdealers/introduction",
  {
    type: "category",
    label: "Business Basics",
    items: [
      "posdealers/business-basics/overview-business-basics",
      "posdealers/business-basics/business-model",
      "posdealers/business-basics/services",
      "posdealers/business-basics/countries",
      "posdealers/business-basics/architecture",
      "posdealers/business-basics/management-portal",
      {
        type: "category",
        label: "Legal & Data Protection",
        items: [
          "posdealers/business-basics/legal-data-protection/fair-use-policy",
        ],
      },
    ],
  },
  {
    type: "category",
    label: "Getting Started",
    items: [
      "posdealers/getting-started/overview-getting-started",
      "posdealers/getting-started/sandbox",
      "posdealers/getting-started/registration",
      "posdealers/getting-started/company-roles",
      {
        type: "category",
        label: "Operator Onboarding",
        items: [
          "posdealers/getting-started/operator-onboarding/invitation-process",
          "posdealers/getting-started/operator-onboarding/surrogating",
          "posdealers/getting-started/operator-onboarding/master-data",
        ],
      },
      "posdealers/getting-started/my-first-cashbox",
    ],
  },
  {
    type: "category",
    label: "Buy & Resell",
    items: [
      "posdealers/buy-resell/overview",
      "posdealers/buy-resell/rollout-plans",
      "posdealers/buy-resell/shop",
      "posdealers/buy-resell/subscription-management",
      {
        type: "category",
        label: "Products & Services",
        items: [
          "posdealers/buy-resell/products/overview",
          "posdealers/buy-resell/products/bundles",
          "posdealers/buy-resell/products/middleware",
          "posdealers/buy-resell/products/digital-receipt",
          "posdealers/buy-resell/products/revision-safe-archiving",

          {
            type: "category",
            label: "Signing devices and services",
            items: [
              "posdealers/buy-resell/products/signing/signing-overview",
              "posdealers/buy-resell/products/signing/rksv-sign",
            ],
          },
          "posdealers/buy-resell/products/notifications",
          "posdealers/buy-resell/products/professional-services",
          {
            type: "category",
            label: "Third party integrations",
            items: [
              "posdealers/buy-resell/products/3rd-party/3rd-party-overview",
              "posdealers/buy-resell/products/3rd-party/datev-meinfiskal",
              "posdealers/buy-resell/products/3rd-party/finanzonline-management",
            ],
          },
        ],
      },
    ],
  },
  {
    type: "category",
    label: "Technical Operations",
    items: [
      "posdealers/technical-operations/overview-technical-operations",
      "posdealers/technical-operations/rollout-scenarios",
      {
        type: "category",
        label: "Middleware",
        items: [
          "posdealers/technical-operations/middleware/overview",
          {
            type: "category",
            label: "Launchers & Hosting",
            items: [
              "posdealers/technical-operations/middleware/launchers/desktop",
              "posdealers/technical-operations/middleware/launchers/android",
              "posdealers/technical-operations/middleware/launchers/custom-data-center",
              "posdealers/technical-operations/middleware/launchers/cloudcashbox",
            ],
          },
          "posdealers/technical-operations/middleware/manual-configuration",
          "posdealers/technical-operations/middleware/cashbox",
          "posdealers/technical-operations/middleware/configuration",
          "posdealers/technical-operations/middleware/helper",
          "posdealers/technical-operations/middleware/logging",
          "posdealers/technical-operations/middleware/setup",
          "posdealers/technical-operations/middleware/supported-environments",
          "posdealers/technical-operations/middleware/network-requirements",
        ],
      },
      {
        type: "category",
        label: "Rollout Automation",
        items: [
          "posdealers/technical-operations/rollout-automation/templates",
          "posdealers/technical-operations/rollout-automation/api-templating",
          "posdealers/technical-operations/rollout-automation/shop-templating",
        ],
      },
      {
        type: "category",
        label: "Troubleshooting",
        items: [
          "posdealers/technical-operations/troubleshooting/troubleshooting-guide",
          "posdealers/technical-operations/troubleshooting/cashbox-failures",
          "posdealers/technical-operations/troubleshooting/network-troubleshooting",
        ],
      },
      {
        type: "category",
        label: "Maintenance",
        items: [
          "posdealers/technical-operations/maintenance/proactive-actions",
          "posdealers/technical-operations/maintenance/updating",
          "posdealers/technical-operations/maintenance/backup-restore",
          "posdealers/technical-operations/maintenance/exports",
        ],
      },
    ],
  },
  {
    type: "category",
    label: "Information Sources",
    items: [
      "posdealers/information-sources/overview-information-sources",
      "posdealers/information-sources/knowledge-base",
      "posdealers/information-sources/cases",
      "posdealers/information-sources/downloads",
      "posdealers/information-sources/status-of-third-party-partners",
      "posdealers/information-sources/news",
      "posdealers/information-sources/videos",
      "posdealers/information-sources/webinars",
      "posdealers/information-sources/contacting-support",
      "posdealers/information-sources/documentation",
    ],
  },
];
