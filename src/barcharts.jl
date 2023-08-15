using CSV
using Plots

# load CSV file(s)
# manually
#csv_files = ["../half_ironman.csv", "../ultramarathon.csv", "../ironman.csv"]

# or select all files in a directory
directory_path = "race-results/"
csv_list = readdir("../")
csv_files = filter(file -> occursin(r"\.csv$", file), csv_list)
full_paths = [joinpath(directory_path, filename) for filename in csv_files]

# dictionary to store year counts for each file
year_counts_dict = Dict{String, Dict{Int, Int}}()

# process each CSV file
for csv_file in full_paths
    data = CSV.File(csv_file)

    year_counts = Dict{Int, Int}()

    for row in data
        year = row.year
        if haskey(year_counts, year)
            year_counts[year] += 1
        else
            year_counts[year] = 1
        end
    end
    year_counts_dict[csv_file] = year_counts
end

# merge year counts from all files
merged_year_counts = Dict{Int, Int}()

for year_counts in values(year_counts_dict)
    for (year, count) in year_counts
        if haskey(merged_year_counts, year)
            merged_year_counts[year] += count
        else
            merged_year_counts[year] = count
        end
    end
end

# extract unique years and their counts
unique_years = sort(collect(keys(merged_year_counts)))
count_values = [merged_year_counts[year] for year in unique_years]

# plot
barchart = bar(unique_years, count_values, xlabel="Year", ylabel="Number of competitions", title="Competitions", legend=false, xticks=unique_years)

# save to file
savefig("competitions.png")
