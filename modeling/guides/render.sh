echo "Usage: sh render.sh [publish]"
GUIDES=../../neo4j-guides
# git clone http://github.com/jexp/neo4j-guides $GUIDES

function render {
  $GUIDES/run.sh index.adoc index.html +1 "$@"
  $GUIDES/run.sh 01_flight_dataset.adoc 01_flight_dataset.html +1 "$@"
  $GUIDES/run.sh 02_flight.adoc 02_flight.html +1 "$@"
  $GUIDES/run.sh 03_flight_booking.adoc 03_flight_booking.html +1 "$@"
  $GUIDES/run.sh 04_specific_relationship_types.adoc 04_specific_relationship_types.html +1 "$@"
  $GUIDES/run.sh 05_refactoring_large_graphs.adoc 05_refactoring_large_graphs.html +1 "$@"

  $GUIDES/run.sh 06_multiple_models.adoc 06_multiple_models.html +1 "$@"
  $GUIDES/run.sh 07_your_turn.adoc 07_your_turn.html +1 "$@"
  $GUIDES/run.sh ../../shared/installing_apoc.adoc installing_apoc.html +1 "$@"
}

# -a env-training is a flag to enable full content, if you comment it out, the guides are rendered minimally e.g. for a presentation
if [ "$1" == "publish" ]; then
  URL=guides.neo4j.com/modeling_airports
  render http://$URL -a csv-url=file:/// -a env-training
  s3cmd put --recursive -P *.html img s3://${URL}/
  s3cmd put -P index.html s3://${URL}
  echo "Publication Done"

  URL=guides.neo4j.com/modeling_sandbox
  render http://$URL -a csv-url=https://raw.githubusercontent.com/neo4j-contrib/training/master/modeling/data/ -a env-training
  s3cmd put --recursive -P *.html img s3://${URL}/
  s3cmd put -P index.html s3://${URL}
  echo "Publication Done"
else
  URL=localhost:8001
# copy the csv files to $NEO4J_HOME/import
  render http://$URL -a csv-url=file:/// -a env-training
  echo "Starting Websever at $URL Ctrl-c to stop"
  python $GUIDES/http-server.py
  # python -m SimpleHTTPServer
fi
