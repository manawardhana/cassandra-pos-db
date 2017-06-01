DROP KEYSPACE busypos;
CREATE KEYSPACE busypos WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
USE busypos;

CREATE TABLE subscription (
  id              TEXT,
  name            TEXT,
  active          BOOLEAN,
  meta            TEXT,
  PRIMARY KEY ((id), name, active) 
);

INSERT INTO subscription (id,         name,              active,      meta)
VALUES                   ('silver',   'Silver Plan',     true,        '{"user_limit":500, "client_limit": 300}');
INSERT INTO subscription (id,         name,              active,      meta)
VALUES                   ('gold',     'Gold Plan',       true,        '{"user_limit":2000, "client_limit": 700}');
INSERT INTO subscription (id,         name,              active,      meta)
VALUES                   ('platinum', 'Platinum Plan',   true,        '{"user_limit":"unlimited", "client_limit": "unlimited"}');

CREATE TABLE tenant (
  tid             TEXT,
  name            TEXT,
  type            TEXT,
  country         TEXT,
  domain          TEXT,
  subscription    TEXT,
  PRIMARY KEY((tid), name)
);

INSERT INTO tenant (tid,             name,               type,               country, domain,                     subscription)
VALUES             ('system',        'System',           null,               null,    'global.busypos.com',       null);
INSERT INTO tenant (tid,             name,               type,               country, domain,                     subscription)
VALUES             ('test-mart',     'Test-Mart',        'general-super',    'US',    'test-mart.busypos.com',    'gold');
INSERT INTO tenant (tid,             name,               type,               country, domain,                     subscription)
VALUES             ('test-fashion',  'Test Fashion',     'fashion',          'US',    'test-fashion.busypos.com', 'gold');
INSERT INTO tenant (tid,             name,               type,               country, domain,                     subscription)
VALUES             ('test-super',    'Test Super',       'general-super',    'UK',    'test-super.busypos.com',   'platinum');
INSERT INTO tenant (tid,             name,               type,               country, domain,                     subscription)
VALUES             ('test-pharma',   'Test Pharma',      'general-pharmacy', 'UK',    'test-pharma.busypos.com',  'silver');

CREATE TABLE user (
  tid             TEXT,
  uname           TEXT,
  fname           TEXT,
  lname           TEXT,
  lid             UUID,
  email           TEXT,
  password        TEXT,
  PRIMARY KEY ((tid, lid), uname, email)
);

INSERT INTO user (tid,         uname,                     fname,      lname,          lid,                                  email,                                 password)
VALUES           ('system',   'admin@busypos.com',        'Tharaka',  'Manawardhana', 7b78c759-d0c6-4f86-a71e-fd450050e5fb, 'admin@busypos.com',                   '5ebe2294ecd0e0f08eab7690d2a6ee69');

INSERT INTO user (tid,         uname,                     fname,      lname,          lid,                                  email,                                 password)
VALUES           ('test-mart', 'ann_smith@test-mart',     'Ann',      'Smith',        7b78c759-d0c6-4f86-a71e-fd450050e5fb, 'ann_smith@test-mart.busypos.com',     '5ebe2294ecd0e0f08eab7690d2a6ee69');
INSERT INTO user (tid,         uname,                     fname,      lname,          lid,                                  email,                                 password)
VALUES           ('test-mart', 'john_peterson@test-mart', 'John',     'Peterson',     7b78c759-d0c6-4f86-a71e-fd450050e5fb, 'john_peterson@test-mart.busypos.com', '5ebe2294ecd0e0f08eab7690d2a6ee69');
INSERT INTO user (tid,         uname,                     fname,      lname,          lid,                                  email,                                 password)
VALUES           ('test-mart', 'mike_gabriel@test-mart',  'Mike',     'Gabriel',      7b78c759-d0c6-4f86-a71e-fd450050e5fb, 'mike_gabriel@test-mart.busypos.com',  '5ebe2294ecd0e0f08eab7690d2a6ee69');
INSERT INTO user (tid,         uname,                     fname,      lname,          lid,                                  email,                                 password)
VALUES           ('test-mart', 'tom_cooper@test-mart',    'Tom',      'Cooper',       7b78c759-d0c6-4f86-a71e-fd450050e5fb, 'tom_cooper@test-mart.busypos.com',    '5ebe2294ecd0e0f08eab7690d2a6ee69');
INSERT INTO user (tid,         uname,                     fname,      lname,          lid,                                  email,                                 password)
VALUES           ('test-mart', 'bill_hunter@test-mart',   'Bill',     'Hunter',       7b78c759-d0c6-4f86-a71e-fd450050e5fb, 'bill_hunter@test-mart.busypos.com',   '5ebe2294ecd0e0f08eab7690d2a6ee69');

CREATE TABLE role (
  tid             TEXT,
  id              UUID,
  code            TEXT,
  name            TEXT,
  global          BOOLEAN,
  permission      LIST<TEXT>,
  PRIMARY KEY ((tid), id)
);

INSERT INTO role(tid,         id,                                    code,               name,                 global, permission)
VALUES          ('system',    71ade24e-679b-4ec3-aad4-8a06c28d618b,  'acc-admin',       'Account Admin',       true,   []);
INSERT INTO role(tid,         id,                                    code,               name,                 global, permission)
VALUES          ('system',    260386c1-b9ac-4aed-895c-69a46e358ce8,  'store-manager',   'Store Manager',       true,   []);
INSERT INTO role(tid,         id,                                    code,               name,                 global, permission)
VALUES          ('system',    ed41c1f4-6980-44e6-872c-0a19a69f9367,  'stock-keeper',    'Stock Keeper',        true,   []);
INSERT INTO role(tid,         id,                                    code,               name,                 global, permission)
VALUES          ('system',    13ba1e7c-86b4-4550-9151-c582d9f26ee1,  'sr-cashier',      'Senior Cashier',      true,   []);
INSERT INTO role(tid,         id,                                    code,               name,                 global, permission)
VALUES          ('system',    44943899-cd52-4df1-b2d3-9f09e7563884,  'cashier',         'Cashier',             true,   []);

CREATE TABLE permission(
  category        TEXT,
  id              TEXT,
  name            TEXT,
  with_concent_of LIST<UUID>,
  cloud           BOOLEAN,
  store           BOOLEAN,
  client          BOOLEAN,
  visible         BOOLEAN,
  editable        BOOLEAN,
  active          BOOLEAN,
  system          BOOLEAN,
  
  PRIMARY KEY ((category, id), active, system, cloud, store, client, visible)
);

INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system )
VALUES                 ('Account Administration', 'create-account',                     'Create Account',                           true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Account Administration', 'edit-account',                       'Edit Account',                             true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Account Administration', 'suspend-account',                    'Suspend Account',                          true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Account Administration', 'activate-account',                   'Activate Account',                         true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Account Administration', 'create-account-admins',              'Create Account',                           true,  true,  true,   true,    true,     true,   false);
                                                                                                                                    
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('User Management',        'create-user',                        'Create User',                              true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('User Management',        'edit-user',                          'Edit User',                                true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('User Management',        'delete-user',                        'Delete User',                              true,  true,  true,   true,    true,     true,   false);
                                                                                                                                    
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Item Management',        'create-item',                        'Create Item',                              true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Item Management',        'edit-item',                          'Edit Item',                                true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Item Management',        'delete-item',                        'Delete Item',                              true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Item Management',        'upc-management',                     'Barcode Management',                       true,  true,  true,   true,    true,     true,   false);
                                                                                                                                    
                                                                                                                                    
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Inventory Management',   'view-stock-own-store',               'View Stock (Own Store)',                   true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Inventory Management',   'view-stock-any-store',               'View Stock (Any Store)',                   true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Inventory Management',   'stock-adjustment-own-store',         'Stock Adjustment (Own Store)',             true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('Inventory Management',   'stock-adjustment-any-store',         'Stock Adjustment (Any Store)',             true,  true,  true,   true,    true,     true,   false);


INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system)
VALUES                 ('POS',                    'pos-item-sales',                     'POS Sales',                                true,  true,  true,   true,    true,     true,   false);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system, with_concent_of)
VALUES                 ('POS',                    'pos-login-allowed-stores',           'POS Login (Allowed Stores)',               true,  true,  true,   true,    true,     true,   false,  [260386c1-b9ac-4aed-895c-69a46e358ce8]);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system, with_concent_of)
VALUES                 ('POS',                    'pos-login-any-store',                'POS Login (Any Store)',                    true,  true,  true,   true,    true,     true,   false,  [260386c1-b9ac-4aed-895c-69a46e358ce8]);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system, with_concent_of)
VALUES                 ('POS',                    'item-void',                          'Item Void',                                true,  true,  true,   true,    true,     true,   false,  [260386c1-b9ac-4aed-895c-69a46e358ce8]);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system, with_concent_of)                       
VALUES                 ('POS',                    'price-override-sales-time',           'Price Override (Sales Time)',              true,  true,  true,   true,    true,     true,   false, [260386c1-b9ac-4aed-895c-69a46e358ce8]);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system, with_concent_of)
VALUES                 ('POS',                    'item-return',                        'Sales Return',                             true,  true,  true,   true,    true,     true,   false,  [260386c1-b9ac-4aed-895c-69a46e358ce8]);
INSERT INTO permission (category,                 id,                                   name,                                       cloud, store, client, visible, editable, active, system, with_concent_of)
VALUES                 ('POS',                    'sales-refund',                       'Sales Refund',                             true,  true,  true,   true,    true,     true,   false,  [260386c1-b9ac-4aed-895c-69a46e358ce8]);

CREATE TABLE location (
  tid             TEXT,
  lid             UUID,
  name            TEXT,
  address         TEXT,
  email           TEXT,
  telephone       TEXT,
  emp             UUID,
  PRIMARY KEY((tid), name)
);

INSERT INTO location (tid,         lid,                                   name,            address,                          email,                                        telephone,      emp)
VALUES               ('test-mart', 5de56dd6-4c58-48dc-85e2-60fc6bcabc91,  'New York',      '45, Park Road, New York',        'newyork-test-store@testmart.busypos.com',    '123368131414', null);
INSERT INTO location (tid,         lid,                                   name,            address,                          email,                                        telephone,      emp)
VALUES               ('test-mart', 8a4c678d-87d8-4675-a32e-9256fca59a7f,  'New Jersey',    '94, Museum Avenue, New Jersey',  'newjersey-test-store@testmart.busypos.com',  '121213567578', null);
INSERT INTO location (tid,         lid,                                   name,            address,                          email,                                        telephone,      emp)
VALUES               ('test-mart', 67251d8a-570c-4f63-97de-6a011bce83a7,  'Boston',        '23/B, Boston, Massachusetts',    'boston-test-store@testmart.busypos.com',     '126245086098', null);
INSERT INTO location (tid,         lid,                                   name,            address,                          email,                                        telephone,      emp)
VALUES               ('test-mart', 0a141f9b-4d69-40a2-bef0-eafbf743e2aa,  'Manhattan',     '09/2B, East Houston, Manhattan', 'manhattan-test-store@testmart.busypos.com',  '093568034516',  null);
INSERT INTO location (tid,         lid,                                   name,            address,                          email,                                        telephone,      emp)
VALUES               ('test-mart', 3db67b38-a8ae-4050-b933-57683ffb0619,  'Manchester',    '31, Lloyd Street, Manchester',   'manchester-test-store@testmart.busypos.com', '870459978625', null);
INSERT INTO location (tid,         lid,                                   name,            address,                          email,                                        telephone,      emp)
VALUES               ('test-mart', e8580a9c-1a43-4d7f-a63c-f661810d6fbf,  'Washington',    '8401, London Place, Washington', 'washington-test-store@testmart.busypos.com', '684634585964', null);


CREATE TABLE supplier_item (
  tid             TEXT,
  id              UUID,
  code            TEXT,
  name            TEXT STATIC,
  item            UUID,
  cost            DECIMAL,
  cost_history    MAP<TIMESTAMP, DECIMAL>,
  PRIMARY KEY((tid, id), code, item) 
);

INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 'united', 'United Distributors', df631c71-015f-4e03-9b56-37f26ab94183, 3.80,   {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 'united', 'United Distributors', ece0a32e-0632-4677-b047-70d60bcde373, 2.10,   {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 'united', 'United Distributors', 15ae1d85-f4f0-46a7-a155-7c3dd51555e9, 6.15,   {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 'united', 'United Distributors', 2e4f44e7-3d90-4228-9fa4-288e4007f27c, 11.57,  {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 'united', 'United Distributors', 56926924-ba80-44f8-a443-6555b6053627, 18.00,  {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  59d7a46a-5888-455d-b44e-67016dfe43b4, 'morgan', 'Morgan Distributors', 8d95715e-7db8-4f4c-b181-7effe19d2271, 6.20,   {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  59d7a46a-5888-455d-b44e-67016dfe43b4, 'morgan', 'Morgan Distributors', e9aa2e52-a8d7-46c2-becf-f2cdc81bb193, 6.50,   {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  59d7a46a-5888-455d-b44e-67016dfe43b4, 'morgan', 'Morgan Distributors', 9b012f4d-e6c6-46be-a42c-a7c823f5eb34, 9.80,   {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  59d7a46a-5888-455d-b44e-67016dfe43b4, 'morgan', 'Morgan Distributors', 3c0c0e2d-254e-41f2-963f-2a8ea9fc0244, 15.49,  {});
INSERT INTO supplier_item (tid,          id,                                   code,     name,                  item,                                 cost,   cost_history)
VALUES                    ('test-mart',  59d7a46a-5888-455d-b44e-67016dfe43b4, 'morgan', 'Morgan Distributors', 54ebb92a-d4cc-4ea7-a72e-eac65e462483, 4.00,   {});


CREATE TABLE item (
  tid             TEXT,
  id              UUID,
  type            TEXT,
  sku             INT,
  name            TEXT,
  display         TEXT,
  print           TEXT,
  uom             TEXT,
  active          BOOLEAN,
  main_sup        UUID,
  main_sup_cost   DECIMAL,
  base_price      DECIMAL,
  price_history   MAP<TIMESTAMP, DECIMAL>,
  PRIMARY KEY ((tid), sku)
);

INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', df631c71-015f-4e03-9b56-37f26ab94183, 'counting', 1000000, 'Lipton Tea bags 100 PCS',                                                             'LIPTON TEA BAGS 100 PCS',                              'LIPTON TEA BAGS 100 PCS',                         'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 3.80,          6.00);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', ece0a32e-0632-4677-b047-70d60bcde373, 'counting', 1000001, 'Lipton Tea bags 50 PCS',                                                               'LIPTON TEA BAGS 50 PCS',                               'LIPTON TEA BAGS 50 PCS',                          'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 2.10,          3.30);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 15ae1d85-f4f0-46a7-a155-7c3dd51555e9, 'counting', 1000002, 'Maggie Noodles (79g) - 6 Pack',                                                        'MAGGI NOODLES (79G) - 6 PACK',                         'MAGGI NOODLES 79G X 6',                           'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 6.15,          7.49);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 2e4f44e7-3d90-4228-9fa4-288e4007f27c, 'counting', 1000003, 'Nutella Chocolate Hazelnut Spread 35.3oz Jar',                                         'Nutella Chocolate Hazelnut 35.3oz Jar',                'Nutella Chocolate Hazelnut 35.3oz Jar',           'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 11.57,         13.50);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 56926924-ba80-44f8-a443-6555b6053627, 'counting', 1000004, 'Milton''s, Craft Bakers, Everything Whole Grain Crackers, 8.3oz Box (Pack of 4)',     'Milton''s, Craft Crackers, 8.3oz X 4',                 'Milton''s, Craft Crackers, 8.3oz X 4',             'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 18.00,         21.43);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 8d95715e-7db8-4f4c-b181-7effe19d2271, 'counting', 1000005, 'Kraft Prepared Pasturized Cheddar Cheese, 7.05 Ounce',                                 'Kraft Cheddar Cheese, 7.05 Oz',                        'Kraft Cheddar Cheese, 7.05 Oz',                   'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 6.20,          7.30);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', e9aa2e52-a8d7-46c2-becf-f2cdc81bb193, 'counting', 1000006, 'Vegemite (220 gram)',                                                                  'Vegemite (220 gram)',                                  'Vegemite (220 gram)',                             'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 6.50,          7.10);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 9b012f4d-e6c6-46be-a42c-a7c823f5eb34, 'counting', 1000007, 'Marmite Big Squeeze 400g',                                                             'Marmite Big Squeeze 400g',                             'Marmite Big Squeeze 400g',                        'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 9.80,          13.01);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 3c0c0e2d-254e-41f2-963f-2a8ea9fc0244, 'counting', 1000008, 'Nestle Milo Chocolate Beverage Mix Jumbo, 3.3 Pound Can',                              'Nestle Milo Chocolate Mix Jumbo, 3.3 Pound Can',       'Nestle Milo Chocolate, 3.3 Pound Can',            'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 15.49,         20.59);
INSERT INTO item (tid,         id,                                   type,       sku,     name,                                                                                  display,                                                print,                                             uom,    active, main_sup,                             main_sup_cost, base_price)
VALUES           ('test-mart', 54ebb92a-d4cc-4ea7-a72e-eac65e462483, 'counting', 1000009, 'Dilmah Tea bags 100',                                                                  'DILMAH TEA BAGS 100',                                  'DILMAH TEA BAGS 100',                             'unit', true,   50b1217a-7cb8-49f9-b0a5-eb18b19f2dba, 4.00,          6.00);
                               
CREATE TABLE upc (
  tid             TEXT,
  item            UUID,
  upc             TEXT,
  type            TEXT,
  PRIMARY KEY ((tid, item), upc)
);
CREATE INDEX item_by_upc ON upc(upc);  

INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', df631c71-015f-4e03-9b56-37f26ab94183, '123456789999', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', ece0a32e-0632-4677-b047-70d60bcde373, '987654321000', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 15ae1d85-f4f0-46a7-a155-7c3dd51555e9, '543210987666', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 2e4f44e7-3d90-4228-9fa4-288e4007f27c, '987654321098', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 56926924-ba80-44f8-a443-6555b6053627, '987654345678', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 8d95715e-7db8-4f4c-b181-7effe19d2271, '987678342748', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', e9aa2e52-a8d7-46c2-becf-f2cdc81bb193, '132534746576', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 9b012f4d-e6c6-46be-a42c-a7c823f5eb34, '543652871087', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 3c0c0e2d-254e-41f2-963f-2a8ea9fc0244, '867354132765', 'UPC-A');
INSERT INTO upc (tid,         item,                                 upc,            type)  
VALUES          ('test-mart', 54ebb92a-d4cc-4ea7-a72e-eac65e462483, '945623187645', 'UPC-A');


CREATE TABLE invoice (
  tid             TEXT,
  lid             UUID, 
  txndate         TIMESTAMP,
  emp             TEXT, 
  device          TEXT, 
  id              VARINT,
  sign            UUID,
  txn_start       TIMESTAMP   STATIC, 
  txn_end         TIMESTAMP   STATIC, 
  customer        TEXT        STATIC,
  loyalty_method  TEXT        STATIC,
  invtype         TEXT        STATIC,
  total           DECIMAL     STATIC,
  dtl_idx         INT,
  sku             INT,
  qty             DECIMAL, 
  adj_qty         DECIMAL, 
  dtltype         TEXT, 
  currency        TEXT        STATIC, 
  price           DECIMAL, 
  scan_time       TIMESTAMP, 
  authorized_by   TEXT,
  PRIMARY KEY ((tid, lid, txndate), emp, device, id, dtl_idx)
);

INSERT INTO invoice (tid,         lid,                                     txndate,       emp,           device,   id,             sign,                                 dtl_idx, txn_start,                   txn_end,                     customer,             loyalty_method,  invtype,   total,       sku,    qty,   adj_qty, dtltype, currency, price,     scan_time,                    authorized_by) 
VALUES              ('test',      5de56dd6-4c58-48dc-85e2-60fc6bcabc91,    '2015-12-27',  'jsmith',      'pos:1',  22221110000001, 2f3fb613-f7a9-4409-bc87-bfb2d71f2284, 0,       '2015-12-27 12:20:30+0600', '2015-12-27 12:22:33+0600',  'jsmith@example.com', 'loyalty_card',  'sales',   1300.00,     100000, 5.00,  null,    'sales', 'LKR',    100.00,    '2015-12-27T12:21:40+06:00',  null);
INSERT INTO invoice (tid,         lid,                                     txndate,       emp,           device,   id,             sign,                                 dtl_idx, sku,    qty,   adj_qty, dtltype, price,    scan_time,                    authorized_by) 
VALUES              ('test',      5de56dd6-4c58-48dc-85e2-60fc6bcabc91,    '2015-12-27',  'jsmith',      'pos:1',  22221110000001, 2f3fb613-f7a9-4409-bc87-bfb2d71f2284, 1,       100001, 2.00,  null,    'sales', 25.00,    '2015-12-27 12:20:40+0600',   null);
INSERT INTO invoice (tid,         lid,                                     txndate,       emp,           device,   id,             sign,                                 dtl_idx, sku,    qty,   adj_qty, dtltype, price,    scan_time,                    authorized_by) 
VALUES              ('test',      5de56dd6-4c58-48dc-85e2-60fc6bcabc91,    '2015-12-27',  'jsmith',      'pos:1',  22221110000001, 2f3fb613-f7a9-4409-bc87-bfb2d71f2284, 2,       100002, 5.00,  null,    'sales', 50.00,    '2015-12-27 12:20:55+0600',   null);
INSERT INTO invoice (tid,         lid,                                     txndate,       emp,           device,   id,             sign,                                 dtl_idx, sku,    qty,   adj_qty, dtltype, price,    scan_time,                    authorized_by) 
VALUES              ('test',      5de56dd6-4c58-48dc-85e2-60fc6bcabc91,    '2015-12-27',  'jsmith',      'pos:1',  22221110000001, 2f3fb613-f7a9-4409-bc87-bfb2d71f2284, 3,       100003, 4.00,  null,    'sales', 250.00,   '2015-12-27 12:21:05+0600',   null);

CREATE TABLE settlement (
  tid             TEXT,
  lid             UUID,
  txndate         TIMESTAMP,
  idx             INT,
  txntime         TIMESTAMP,
  invoice         UUID,
  method          TEXT,
  amount          DECIMAL,
  reference_id    TEXT,
  meta_data       TEXT,
  PRIMARY KEY ((tid, lid, txndate), invoice, idx)
);
--INSERT INTO settlement (tid, lid, txndate, idx, txntime, invoice, method, reference_id, meta_data) 
--VALUES                 ('test', );


CREATE TABLE inventory (
  tid             TEXT,
  lid             UUID,
  item            UUID,
  count           DECIMAL,
  PRIMARY KEY ((tid, lid), item)
);
