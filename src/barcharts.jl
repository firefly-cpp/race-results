using CSV
using Plots

# load CSV file
data = CSV.File("half_ironman.csv")

# extract attribute (years as for examples)
years = data.year

year_counts = Dict{Int, Int}()

# count the occurrences of each year
for row in data
           year = row.year
           if haskey(year_counts, year)
               year_counts[year] += 1
           else
               year_counts[year] = 1
           end
       end

# extract unique years and their counts
unique_years = sort(collect(keys(year_counts)))
count_values = [year_counts[year] for year in unique_years]

# plot
bar(unique_years, count_values, xlabel="Year", ylabel="Number of competitions", title="Triathlons", legend=false, xticks=unique_years)

