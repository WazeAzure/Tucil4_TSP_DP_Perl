use strict;
use warnings;
use List::Util qw(min);

# filename
my $filename = "input-4.txt";

# open file
open my $fh, '<', $filename or die "File '$filename' can't be opened";

# parsing proses
my @file_content = <$fh>;

# close file handler;
close $fh;

# Remove any trailing newlines from each line
chomp @file_content;

# get matrix size
my $matrix_size = shift @file_content;

# initialize matrix
my @matrix;

# initialize matrix content
for my $line (@file_content) {
    my @row = split ' ', $line;
    push @matrix, \@row;
}

# ASUMSI: INFINITE diubah menjadi angka 999
print "Matrix:\n";
for my $row (@matrix) {
    print join(' ', @$row), "\n";
}

# Number of node
my $n = scalar @matrix;

# Hash table untuk visited
# Memoization hash
my %is_visited;

# Recursive function to solve the TSP problem
sub tsp {
    my ($subset, $i) = @_;
    
    # If the result is already computed, return it
    return $is_visited{$subset}{$i} if exists $is_visited{$subset}{$i};
    
    # Base case: if subset is just the starting node
    if ($subset == (1 << $i)) {
        $is_visited{$subset}{$i} = $matrix[0][$i];
        return $matrix[0][$i];
    }
    
    # Initialize minimum cost to a large value
    my $min_cost = 1e9;
    
    # Iterate through all nodes to find the minimum cost
    for my $j (0..$n-1) {
        next if $j == $i || !($subset & (1 << $j));
        
        # Recursive call
        my $cost = tsp($subset ^ (1 << $i), $j) + $matrix[$j][$i];
        $min_cost = min($min_cost, $cost);
    }
    
    # is_visited the result
    $is_visited{$subset}{$i} = $min_cost;
    return $min_cost;
}

# Initialize the result
my $final_result = 1e9;

# Iterate over all possible ending nodes
for my $i (1..$n-1) {
    my $cost = tsp((1 << $n) - 1, $i) + $matrix[$i][0];
    $final_result = min($final_result, $cost);
}


print "Minimum cost adalah: $final_result\n";
