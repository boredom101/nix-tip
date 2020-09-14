import sys
import pprint
import json

pp = pprint.PrettyPrinter(indent=4)

configs = {}
results = {}
outputs = []

counter = 0

thresh = int(sys.argv[1])
outpath = sys.argv[2]

def isEnable(item):
    return item.endswith(".enable")

def isHardware(item):
    return item.startswith("hardware.")

def onlyOne(item1, item2, cond):
    if (cond(item1) and not cond(item2)):
        return [item1, item2]
    elif (cond(item2) and not cond(item1)):
        return [item2, item1]
    else:
        return []

conds = [isHardware, isEnable]

def analyze(item1, item2):
    for cond in conds:
        temp = onlyOne(item1, item2, cond)
        if temp:
            return temp
    if item1 < item2:
        return [item1, item2]
    return [item1, item2]

def jaccard(list1, list2):
    intersection = len(list(set(list1).intersection(list2)))
    union = (len(list1) + len(list2)) - intersection
    return intersection / union

for line in sys.stdin:
    line = line.strip()[1:-1]
    config = line.split(';')
    for item in config:
        if item in configs.keys():
            configs[item].append(counter)
        else:
            configs[item] = [counter]
    counter = counter + 1

keys = []
for key in configs.keys():
    if len(configs[key]) == 1:
        keys.append(key)

for key in keys:
    del(configs[key])

for conf1 in configs.keys():
    for conf2 in configs.keys():
        if conf1 != conf2 and not (conf2 + "+" + conf1) in results.keys():
            results[conf1 + "+" + conf2] = jaccard(conf1, conf2)

for key in results.keys():
    results[key] = round(100 * results[key])
    if results[key] >= thresh:
        temp = key.split("+")
        ifValue, thenValue = analyze(temp[0], temp[1])
        outputs.append({"weight": results[key], "ifValues": [ifValue], "thenValue": thenValue})

with open(outpath, 'w') as fp:
    json.dump(outputs, fp)