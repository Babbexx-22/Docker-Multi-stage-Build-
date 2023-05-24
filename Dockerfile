# Stage 1: Build Stage
FROM ubuntu:20.04 AS build

# Install dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
       curl \
       osmium-tool \
    && rm -rf /var/lib/apt/lists/*

# Create directories &&& download/merge OSM files
RUN mkdir /osmfiles /merged \
    && curl -o /osmfiles/monaco.osm.pbf http://download.geofabrik.de/europe/monaco-latest.osm.pbf \
    && curl -o /osmfiles/andorra.osm.pbf http://download.geofabrik.de/europe/andorra-latest.osm.pbf \
    && osmium merge /osmfiles/monaco.osm.pbf /osmfiles/andorra.osm.pbf -o /merged/merged.osm.pbf

# Stage 2: Final Stage
FROM alpine AS final

# Create the /merged directory
RUN mkdir /merged

# Copy merged OSM files from the build stage
COPY --from=build /merged /merged
