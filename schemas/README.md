# Shopify GraphQL Schemas

Schemas are generated through GraphQL's introspection capabilities. The `rover` CLI (part of the Apollo project) is used to issue the query:

```sh
rover graph introspect https://my-store.myshopify.com/admin/api/2022-07/graphql.json --header "X-Shopify-Access-Token: <access-token>" > admin/2022-07.graphql
```
