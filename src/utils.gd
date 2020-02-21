extends Node

func map(input: Array, function: FuncRef) -> Array:
	var mapped_result = []
	for el in input:
		mapped_result.append(function.call(el))
	return mapped_result

func filter(input: Array, function: FuncRef) -> Array:
	var filtered_result = []
	for el in input:
		if function.call(el):
			filtered_result.append(el)
	return filtered_result

func reduce(input: Array, function: FuncRef, base = null) -> Array:
	var reduced_result = base
	var index := 0
	if not base and input.size() > 0:
		reduced_result = input[0]
		index = 1
	for i in range(index, input.size()):
		reduced_result = function.call(reduced_result, input[i])
	return reduced_result
