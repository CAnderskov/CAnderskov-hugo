+++
title = "Bash/JQ To Influx Http API"
menu = "post"
Categories = ["Development","bash", "json", "inlfuxdb"]
Tags = ["Development","bash", "json", "inlfuxdb"]
Description = ""
date = "2017-01-30T09:34:12+01:00"

+++

### Why
> [Telegraf](https://github.com/influxdata/telegraf) supports reading json and writing it to influxdb, however as of writing this, it only support grabbing numeric values, I need to grab text as well. 

> Im sure there are smarter easier ways of doing this, and id love to hear about em, for now, this is what i was able to come up with

```bash
#!/bin/sh

#JSON to influx line protocol reformatter, Since the built in json parser of telegraf have a bug handling arrays the simplets way to get arrays of datas into influx was to write this simple reformatter, from json to line.
# By Christian Anderskov Petersen christian@anderskov.dk

#Get the JSON and stick it in a variable we can pullout our data from
OUTPUT=$(curl -sS --header 'Accept: application/json' -X GET 'http://jsonurl')

# INFLUXDB CONNECTION STRING
INFLUXHOST='http://localhost:8086/write?db=influxdb'
AUTHDETAILS='XXXXXXXX:XXXXXXXX'

# Define root element and which child nodes to pick out from the selected root element, if more CHILDS are add'd the below while statement will have to be updated accordingly, not that influx does not allow for whitespces in its input, so if new add'd childs might contain spaces the "sed" whille have to be used to "escape" the whitespace before input.
ROOT_NODE='ServerNames'
TIME_NODE='Time'
CHILD_NODE_FIRST='servername'
CHILD_NODE_SECOND='Count'

#Count the amount of json we got to loop through
END=$( echo "$OUTPUT" | jq --arg x $ROOT_NODE '.'$ROOT_NODE' | length')

i=0
while [ $i -lt $END ]; do
        #sed command explained: influx does not allow space, comma or equeal signs in its input, therefore they need to be escaped with a \
        TIME=$( echo "$OUTPUT" | jq -r --arg x $i --arg y $ROOT_NODE --arg z $TIME_NODE '.'$ROOT_NODE'['$i'].'$TIME_NODE'')
        FIRST=$( echo "$OUTPUT" | jq -r --arg x $i --arg y $ROOT_NODE --arg z $CHILD_NODE_FIRST '.'$ROOT_NODE'['$i'].'$CHILD_NODE_FIRST'' |  sed -e "s/ /\\\ /g;
s/=/\\\=/g; s/,/\\\,/g")
        SECOND=$( echo "$OUTPUT" | jq -r --arg x $i --arg y $ROOT_NODE --arg z $CHILD_NODE_SECOND '.'$ROOT_NODE'['$i'].'$CHILD_NODE_SECOND'')

        RESULT=$( echo $ROOT_NODE,$CHILD_NODE_FIRST\=$FIRST $CHILD_NODE_SECOND\=$SECOND $TIME)
        curl -i -silent -XPOST "$INFLUXHOST" -u "$AUTHDETAILS" --data-binary "$RESULT" > /dev/null

        let i=i+1
done
DATE=$(date +"%c")
echo $DATE - Wrote $i entries to $INFLUXHOST >> /var/log/influxcollectors/$ROOT_NODE.log
```

