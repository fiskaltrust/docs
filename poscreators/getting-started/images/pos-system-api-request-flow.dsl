/*
 * POS System API – End-to-End Request Flow
 *
 * Structurizr DSL source for `pos-system-api-request-flow.svg`.
 *
 * The Structurizr renderer draws dynamic views as box-and-arrow diagrams
 * with numbered edges; it has no built-in "sequence diagram" mode. To get
 * a true sequence diagram, export the dynamic view to PlantUML or Mermaid
 * (both natively support sequence diagrams) and render that.
 *
 * Render with:
 *   - Structurizr Lite (Docker): run `structurizr/lite` against this file,
 *     open the "PosSystemApiRequestFlow" view, then use the diagram
 *     toolbar's Export button to copy the PlantUML or Mermaid source.
 *     Render the resulting `@startuml` / `sequenceDiagram` snippet on
 *     https://www.plantuml.com/plantuml or https://mermaid.live.
 *   - Structurizr CLI:
 *       structurizr-cli export -workspace pos-system-api-request-flow.dsl -format mermaid
 *     (or `-format plantuml`). The dynamic view is emitted as a
 *     `sequenceDiagram` (Mermaid) / sequence diagram (PlantUML).
 *   - https://playground.structurizr.com previews only the standard
 *     Structurizr renderer; use its Export menu and the same
 *     PlantUML/Mermaid rendering step above.
 *
 * When the diagram changes, edit this file and regenerate the SVG — keep
 * the two files in sync.
 */

workspace "fiskaltrust POS System API" "End-to-end request flow between a POS system, the fiskaltrust.Middleware and country-specific signing components." {

    model {
        pos = softwareSystem "POS System" "Cash register that integrates with fiskaltrust via the POS System API." {
            tags "POS"
        }

        middleware = softwareSystem "fiskaltrust.Middleware" "Exposes the POS System API and orchestrates fiscalization, payment, issuing and journaling." {
            tags "Middleware"

            posApi       = container "POS System API"   "HTTP endpoints (/echo, /order, /pay, /sign, /issue, /journal) consumed by the POS." "REST API"
            queue        = container "Action queue"     "Orchestrates order, payment, signing, issuing and journaling actions; persists state for retries."
            scuProxy     = container "SCU / TSE proxy"  "Country-specific adapter that forwards signing requests to the signing component."
            journalStore = container "Journal store"    "Local persistence for the receipt chain and audit / closing exports." "Database"
        }

        signing = softwareSystem "Signing component & Cloud" "Country-specific signing component (SCU / TSE / RT / …) and the fiskaltrust.Cloud." {
            tags "Signing"
        }

        # Model-level relationships that back the ordered interactions in the dynamic view.
        pos        -> middleware "Calls POS System API endpoints (/echo, /order, /pay, /sign, /issue, /journal)"
        middleware -> pos        "Returns API responses"
        middleware -> signing    "Performs country-specific signing and uploads the receipt chain"
        signing    -> middleware "Returns signature data and configuration / updates"

        # Container-level relationships that back the container view.
        pos          -> posApi       "Calls POS System API endpoints" "HTTPS / JSON"
        posApi       -> queue        "Enqueues orders, payments, signing, issuing and journaling actions"
        queue        -> scuProxy     "Requests receipt signing"
        queue        -> journalStore "Persists receipt chain and exports"
        scuProxy     -> signing      "Forwards signing requests and uploads receipt chain"
        signing      -> scuProxy     "Returns signature data and configuration / updates"
    }

    views {
        container middleware "MiddlewareContainers" "Internal containers of the fiskaltrust.Middleware that implement the POS System API." {
            include *
            autoLayout lr
        }

        dynamic * "PosSystemApiRequestFlow" "Every request carries x-cashbox-id, x-cashbox-accesstoken, x-possystem-id and x-operation-id — safe to retry without duplicating fiscal actions." {

            # /echo
            pos        -> middleware "/echo  (health check)"
            middleware -> pos        "echo response"

            # /order
            pos        -> middleware "/order  (register order data)"
            middleware -> pos        "order state"

            # /pay
            pos        -> middleware "/pay  (process payment)"
            middleware -> pos        "payment state"

            # /sign  (with country-specific signing round-trip)
            pos        -> middleware "/sign  (fiscalize receipt)"
            middleware -> signing    "country-specific signing"
            signing    -> middleware "signature data"
            middleware -> pos        "signed receipt data"

            # /issue
            pos        -> middleware "/issue  (generate receipt output)"
            middleware -> pos        "digital / printable receipt"

            # /journal  (with cloud round-trip)
            pos        -> middleware "/journal  (audit / closing exports)"
            middleware -> signing    "upload receipt chain"
            signing    -> middleware "configuration / updates"
            middleware -> pos        "journal data"

            autoLayout lr
        }

        styles {
            element "Software System" {
                shape RoundedBox
                background #e8f0fb
                color #1f3a5f
                stroke #1f3a5f
            }
            element "Container" {
                shape RoundedBox
                background #d6e4f7
                color #1f3a5f
                stroke #1f3a5f
            }
            element "Database" {
                shape Cylinder
            }
            element "Signing" {
                background #fff2dc
                color #7a4a00
                stroke #7a4a00
            }
        }
    }
}
