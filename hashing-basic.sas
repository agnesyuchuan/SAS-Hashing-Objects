/***Hashing in SAS***/
/* Sample Customer Data */
data Customers;
  input Customer_ID $ Customer_Name $ Age;
  datalines;
C001 John 25
C002 Jane 30
C003 Bob 28
;

/* Sample Purchase Data */
data Purchases;
  input Customer_ID $ Product $ Price;
  datalines;
C001 Laptop 1200
C002 Smartphone 800
C001 Tablet 500
C003 Headphones 150
C002 Smartwatch 300
;

/* Create a new dataset to store the combined information */
data CombinedData;
  /* Initialize the HASH object */
  if _N_ = 1 then do;
    declare hash Customers(dataset: 'Customers');
    declare hiter CustomersIterator('Customers');
    declare hash Purchases(dataset: 'Purchases');
    declare hiter PurchasesIterator('Purchases');
    
    /* Define the key for the hash object */
    Customers.defineKey('Customer_ID');
    Customers.defineData('Customer_Name', 'Age');
    
    Purchases.defineKey('Customer_ID');
    Purchases.defineData('Product', 'Price');
    
    /* Compile the hash objects */
    Customers.defineDone();
    Purchases.defineDone();
  end;

  /* Set the key for the hash objects */
  set Customers;
  rc = Customers.find();

  /* Check if the customer has purchases */
  if rc = 0 then do;
    /* Output customer information */
    output CombinedData;

    /* Iterate through the purchases and output */
    do while (Purchases.find(key: Customer_ID) = 0);
      output CombinedData;
    end;
  end;
run;

/* Display the combined data */
proc print data=CombinedData;
run;
