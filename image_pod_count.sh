# Parameter check
if [ -z "$1" ]; then
  echo "Usage: ./(script) TARGET_IMAGE_SUBSTRING";
  exit 0
fi

# Setup counts
bcCount=0;
dcCount=0;

for project in $(oc get projects -o jsonpath='{.items[*].metadata.name}');
do
  #echo $project;
  for bc in $(oc get bc -n $project -o jsonpath='{.items[*].metadata.name}');
  do
    imageName=$(oc get bc $bc -n $project -o jsonpath='{$.spec.strategy..from.name}');
    #echo "  "$bc" "$imageName;

    # Check the bc for target image name
    if grep -q $1 <<<$imageName; then

      dc_count=$(oc get dc $bc -n $project -o jsonpath='{.status.replicas}');

      echo "[Found] "$dc_count" replicas of "$imageName;
      bcCount=$(($bcCount+$dc_count));
    fi
  done
done

echo "Total of Pods via BC match: "$bcCount
