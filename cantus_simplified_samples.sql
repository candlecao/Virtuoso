CREATE TABLE "R2RML_cantus"."TEST"."Cantus"(
  id VARCHAR(100) primary key,
  incipit VARCHAR(100),
  genre_ObjectProperty VARCHAR(100),
  genre_DatatypeProperty VARCHAR(100),
  src_link VARCHAR(100)
);

INSERT SOFT "R2RML_cantus"."TEST"."Cantus" VALUES ('562633', 'Ecce nunc palam loqueris et ', 'http://www.wikidata.org/entity/Q582093', '', 'https://cantusdatabase.org/source/123756');
INSERT SOFT "R2RML_cantus"."TEST"."Cantus" VALUES ('560432', 'Loquetur pacem gentibus et potestas ', '', 'Responsory verse', 'https://cantusdatabase.org/source/123756');

SPARQL CLEAR GRAPH <http://temp/product>;
--the Name of the Graph:
SPARQL CLEAR GRAPH <http://example.com/>;

DB.DBA.TTLP ('
@prefix rr: <http://www.w3.org/ns/r2rml#> .
@prefix cantusDB: <https://cantusdatabase.org/> .
@prefix schema: <http://schema.org/> .
@prefix wdt: <http://www.wikidata.org/prop/direct/> .

<http://example.com/ns#TriplesMap1>
    a rr:TriplesMap;

    rr:logicalTable
    [
      rr:tableSchema "R2RML_cantus";
      rr:tableOwner "TEST";
      rr:tableName "Cantus"
    ];

    rr:subjectMap
    [
      rr:template "https://cantusdatabase.org/chant/{id}";
      rr:class cantusDB:chant;
      rr:graph <http://example.com/>;
    ];

    rr:predicateObjectMap
    [
      rr:predicate wdt:P1922;
      rr:objectMap [ rr:column "incipit" ];
    ];

    rr:predicateObjectMap
    [
      rr:predicate wdt:P136;
      rr:objectMap [ rr:column "genre_ObjectProperty" ];
    ];

    rr:predicateObjectMap
    [
      rr:predicate schema:genre;
      rr:objectMap [ rr:column "genre_DatatypeProperty" ];
    ];

    rr:predicateObjectMap
    [
      rr:predicate cantusDB:sources;
      rr:objectMap [ rr:column "src_link" ];
    ];
.
', 'http://temp/product', 'http://temp/product' )
;

--select DB.DBA.R2RML_TEST ('http://temp/product');

--DB.DBA.OVL_VALIDATE ('http://temp/product', 'http://www.w3.org/ns/r2rml#OVL');

-- Running the validation in order to find error in name of R2RML description graph
--DB.DBA.OVL_VALIDATE ('http://temp/product-nosuch', 'http://www.w3.org/ns/r2rml#OVL');

-- Running the validation in order to find error in name of R2RML metadata graph
--DB.DBA.OVL_VALIDATE ('http://temp/product', 'http://www.w3.org/ns/r2rml#OVL-nosuch');

--select DB.DBA.R2RML_EXECUTE ('http://temp/product');

exec ('sparql ' || DB.DBA.R2RML_MAKE_QM_FROM_G ('http://temp/product'));

--sparql select distinct ?g where { graph ?g { ?s a ?t }};

SPARQL
SELECT * FROM <http://example.com/>
WHERE {?s ?p ?o .};