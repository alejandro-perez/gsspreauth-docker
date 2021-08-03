# How to test

1. In one terminal, execute

   ```bash
   docker-compose --build up
   ```

   That will take a while, but will build a KDC and a moonshot IDP

2. In another terminal, same folder, execute:

   ```bash
   docker-compose exec kdc -- kinit -u 200 -X "gss_mech=1.3.6.1.5.5.15.1.1.17" -X gss_default -X gss_federated
   ```

   That will execute the kinit application from within the `kdc` container. Use `alex@test.org` with password `alex` 

   Alternatively, you can get a shell in the `kdc` container with:

   ```bash
   docker-compose exec kdc bash
   ```

   And then launch the kinit command with:

   ```bash
   kinit -u 200 -X "gss_mech=1.3.6.1.5.5.15.1.1.17" -X gss_default -X gss_federated
   ```

   