# dbt Project & Call Durations Analysis

## Introduction

This repository houses a dbt (data build tool) project. It's meticulously tailored to guide users through the processes of establishing dbt seeds and models, whether for testing or experimental intents. Thanks to Docker's seamless integration, users benefit from an environment that simplifies the creation and management of data models in a Postgres database.

## Table of Contents

- [Setting Up the Environment](#setting-up-the-environment)
  - [Prerequisites](#prerequisites)
  - [Project Structure](#project-structure)
  - [Environment Variables](#environment-variables)
  - [Running the dbt Project](#running-the-dbt-project)
- [Call Durations Analysis Data Model](#call-durations-analysis-data-model)
  - [Purpose](#purpose)
  - [Model Overview](#model-overview)
  - [Columns Description](#columns-description)
  - [Business Significance](#business-significance)

## Setting Up the Environment

### Prerequisites

- Docker should be up and running on your machine.

### Project Structure

- `Dockerfile`: This script embodies the blueprint for our dbt environment, detailing dependencies.
- `docker-compose.yml`: Orchestrating two pivotal services—`postgres` (our database) and `dbt` (our ELT tool).

### Environment Variables

Spawn a `.env` file in the project's root directory, referencing the prototype `.env.example` for guidance.

### Running the dbt Project

```bash
docker-compose build
```
```commandline
docker-compose up
```

This will spin up two containers namely `dbt` (out of the `dbt` image) and `postgres` (out of the
`postgres` image).

# Call Durations Analysis Data Model

## Purpose
This data model aims to compute and rank call durations for individual calls. It calculates the duration a call was in the queue, the actual call duration, and the total time taken from the moment the call was queued to its completion. This information is vital for stakeholders looking to understand the efficiency of the call processing system and identify areas that may require improvement.

## Model Overview

The model logic is broken down into three main stages:

1. **Call Stages Extraction**:
    - For each `id` (representing individual calls), the model captures the following timestamps:
        - Time when the call was queued (`queue_start`).
        - Time when the call was initiated (`call_start`).
        - Time when the call ended (`call_end`).
    - It also identifies the manner in which the call concluded, distinguishing between calls that were answered and those that weren't (`call_end_status`).

2. **Call Durations Computation**:
    - For each call (`id`), the model calculates:
        - The duration for which the call waited in the queue before being picked up (`queue_duration`).
        - The length of the actual call conversation (`call_duration`).
        - The entire time elapsed from the moment the call was queued to when it ended (`total_duration`).

3. **Ranking**:
    - The model ranks calls based on:
        - The total call duration.
        - The time in the queue.
        - The actual call length.

## Columns Description

- `id`: A unique identifier assigned to each call.
  
- `call_end_status`: Indicates how the call ended. This can help identify whether the call was answered or not.

- `queue_duration`: Represents the duration for which the call was in the queue before it started.

- `call_duration`: Specifies the time for which the call was active (from start to end).

- `total_duration`: Captures the entire time from the moment the call was queued until it concluded.

- `rank_by_total_duration`: Ranks calls based on `total_duration`.

- `rank_by_queue_duration`: Ranks calls by `queue_duration`.

- `rank_by_call_duration`: Sorts calls according to `call_duration`.

## Business Significance

Analyzing these durations and their rankings can aid businesses in pinpointing bottlenecks within their call handling mechanisms. For instance, a lengthy `queue_duration` might be indicative of insufficient staffing during high-traffic periods. Conversely, an unusually prolonged `call_duration` could hint at complications within the call itself or the overarching process.


