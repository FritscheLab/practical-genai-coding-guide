# Project Plan Template (General Placeholders)

Replace each [PLACEHOLDER: …] with your project specifics. Keep the section names and ordering to ensure consistency across projects.

---

**Data Description**  
Primary dataset:
- Source/location: [PLACEHOLDER: path/URI/system]
- Format: [PLACEHOLDER: CSV/TSV/Parquet/DB table/API]
- Row grain: [PLACEHOLDER: one row per entity/event/transaction]
- Key columns: [PLACEHOLDER: primary keys, business keys]
- Time fields: [PLACEHOLDER: date/time columns and time zone]
- Units/encodings: [PLACEHOLDER: units, categories, code systems]
- Expected size: [PLACEHOLDER: rows, columns]

Secondary dataset(s) (if any):
- Source/location: [PLACEHOLDER]
- Join keys: [PLACEHOLDER]
- Purpose: [PLACEHOLDER: enrich, reference, labels]

Derived variables needed:
- [PLACEHOLDER: normalized fields, computed metrics, flags, labels]

Assumptions/notes:
- [PLACEHOLDER: caveats about data provenance, refresh cadence, access]

---

**Task to Be Accomplished**

1. **Data Ingestion**  
  - Environment/Language: [PLACEHOLDER: R/Python/SQL]  
  - Packages/Versions: [PLACEHOLDER: packageA vX.Y, packageB vZ]  
  - Steps:  
    - Read inputs from [PLACEHOLDER: paths/endpoints].  
    - Enforce schemas and data types; parse dates/times with [PLACEHOLDER: tz].  
    - Normalize identifiers (trim, case, unicode) and handle missing values with [PLACEHOLDER: policy].  
    - Persist raw snapshots to [PLACEHOLDER: storage/location].

2. **Data Cleaning and Filtering**  
  - Validation rules: [PLACEHOLDER: field-level constraints, ranges, regex].  
  - Deduplication: [PLACEHOLDER: keys + tie-breakers].  
  - Standardization: [PLACEHOLDER: units, categories, code mappings].  
  - Outlier/anomaly detection: [PLACEHOLDER: statistical rules/model, thresholds].  
  - Business rules/exclusions: [PLACEHOLDER: domain-specific filters].  
  - Logging: write rejected rows and reasons to [PLACEHOLDER: path/table].

3. **Representative Record Selection**  
  - Entity grain for final output: [PLACEHOLDER: per user/order/product/etc.].  
  - Selection window: [PLACEHOLDER: start/end relative to index date/event].  
  - Criteria: [PLACEHOLDER: latest/closest/median/score-based].  
  - Tie-breakers: [PLACEHOLDER: rule order].  
  - Index date definition (if applicable): [PLACEHOLDER].

4. **Categorization of Key Variables**  
  - Variable A categories: [PLACEHOLDER: bins/labels/rules].  
  - Variable B segments: [PLACEHOLDER].  
  - Mapping source and version: [PLACEHOLDER].  
  - Sensitivity variants (optional): [PLACEHOLDER].

---

**Expected Output**

1. **Cleaned Dataset**  
  - Format/location: [PLACEHOLDER: CSV/Parquet/DB table at path].  
  - Row grain: [PLACEHOLDER].  
  - Columns: [PLACEHOLDER: list or pointer to data dictionary].  
  - Constraints/quality gates: [PLACEHOLDER: not-null, uniqueness, ranges].

2. **Summary Report**  
  - Contents: [PLACEHOLDER: row counts per step, exclusion reasons, distributions, charts].  
  - Format/location: [PLACEHOLDER: Markdown/HTML/Dashboard at path].

3. **Data Dictionary**  
  - For each column: name, type, description, allowed values, lineage/provenance.  
  - Location: [PLACEHOLDER: path/wiki].

4. **Additional Considerations**  
  - Reproducible rules (final thresholds/parameters): [PLACEHOLDER].  
  - Parameterization/config: [PLACEHOLDER: .env/JSON/YAML].  
  - Performance: [PLACEHOLDER: expected runtime, memory, partitioning].  
  - Privacy/ethics/compliance: [PLACEHOLDER: PII/PHI handling, approvals].  
  - Governance/versioning: [PLACEHOLDER: repo, tags, data versions].

---

**Implementation Checklist (Quick Fill)**
- [ ] Confirm input sources, schemas, and access
- [ ] Define validation rules and unit/category mappings
- [ ] Choose selection window, criteria, and tie-breakers
- [ ] Specify categories/segments and sensitivity variants
- [ ] Set output formats/paths and reporting artifacts
- [ ] Record package versions and configuration

---

**References (optional)**
- [PLACEHOLDER: Domain standards/specifications]
- [PLACEHOLDER: Internal guidelines/playbooks]
- [PLACEHOLDER: External references/tool docs]
