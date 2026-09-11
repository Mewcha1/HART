# Quality Assurance & Data Management


<div class="phase-banner">
  <strong>Project status — implementation phase.</strong> The January 2027 field launch is being prepared. Quantities described as targets, hypotheses, or planned outcomes are <strong>not project results</strong> and will be replaced with measured results as they become available.
</div>


The project is developing a **Quality Assurance Project Plan (QAPP)** for EPA review. The public website should summarize the QA framework without replacing the controlled QAPP, laboratory SOPs, chain-of-custody records, or internal project repositories.

## Data-quality objectives

The QAPP is structured so environmental information is suitable for decisions about nutrient leaching, crop performance, watershed load reduction, and predicted red-tide risk. Key data-quality indicators include:

<div class="dq-grid">
<div><b>Precision</b><span>duplicates and repeatability</span></div>
<div><b>Accuracy / bias</b><span>calibration, spikes, standards and blanks</span></div>
<div><b>Completeness</b><span>target ≥90% usable planned measurements</span></div>
<div><b>Representativeness</b><span>replicates, seasons, depths and forcing records</span></div>
<div><b>Comparability</b><span>consistent methods, units and metadata</span></div>
<div><b>Sensitivity</b><span>reporting limits adequate for project questions</span></div>
<div><b>Traceability</b><span>unique identifiers and linked records</span></div>
<div><b>Reproducibility</b><span>versioned code, model inputs and environments</span></div>
</div>

## Environmental information flow

<div class="flow-row wrap">
<div><b>Acquire</b><br><small>field · lab · sensor · UAV · existing data</small></div><i>→</i>
<div><b>Verify</b><br><small>IDs · metadata · calibration · custody</small></div><i>→</i>
<div><b>Validate</b><br><small>QC acceptance · qualification · corrective action</small></div><i>→</i>
<div><b>Use</b><br><small>analysis · WAM · ML · dashboard</small></div><i>→</i>
<div><b>Archive</b><br><small>raw + qualified + versioned records</small></div>
</div>

## Main project data streams

| Data stream | Examples | Public release plan |
|---|---|---|
| Lysimeter & water quality | TN, TP, nitrate/nitrite, ammonia, SRP, pH, EC | Post-QA summary tables and approved datasets |
| Sensor & weather | soil water, temperature, water potential, groundwater level, rainfall | Time-series summaries; raw files when approved |
| Agronomic | treatment application, soil, biomass, yield, fruit quality | Task 1/2 results and metadata |
| UAV | flight logs, imagery, orthomosaics, vegetation indices | Selected maps/figures; raw imagery subject to data policy |
| Watershed & ML | model inputs/outputs, scenarios, uncertainty, performance | Reproducible releases and figures |
| Decision-support | source manifest, evaluation records, dashboard releases | Public prototype and documented source base |

## Public-site rule

Only **quality-reviewed and release-approved** results should move from the internal project repository to this GitHub site. Draft QAPP details, unvalidated measurements, laboratory identifiers, and internal QA records should remain in controlled project storage unless specifically approved for public release.
