Waiter - Iterate Implemented with CL-Walker
===========================================

As the name suggests, this is a (partial) implementation of iterate
using cl-walker. The code is very experimental right now and only a
few iterate clauses are actually implemented.

Implementation
--------------

The code currently works in four steps.

1. Parse the code using cl-walker.

   This step uses cl-walker to parse the code into objects. This is
   done by having some code handle the iterate clauses and then
   relying on cl-walker to parse the rest.

2. Walk along the ast and collect data.

   By using ast-map in cl-walker, map over the ast with a visitor
   object which will gather all of the information needed for the
   iterate form. The information gained in this step includes the
   finally and initially clauses, as well as any variables that need
   to be bound.

3. Walk along the ast and transfer data to the forms.

   A second pass is made over the ast which gives each form the
   specific information it needs in order to do its job. For example,
   any form which can terminate needs to have the tag of where to jump
   to when actually terminating.

4. Unwalk the code.

   This step consists of walking along the objects and converting them
   back into code.


Adding Your Own Clauses
-----------------------
Defining clauses with macros is implemented, so if you can express
whatever clause you want to define in terms of other ones, all you
need to do is define a macro that performs the correct expansion.

If the clause is more complicated, you will have to add your own
primitive clause. To add your own primitive iterate clause, you need
to do a total of six things.

1. Define the class that will represent your clause.
2. Write the parser for your clause using defiter-handler.
3. Write the unwalker for your clause using defunwalker-handler.
4. Specify what data should be gathered from your clause using the
collect-data method.
5. Specify what data your clause needs to know using transfer-data.
6. Specify how to map over your clause by using defmap.