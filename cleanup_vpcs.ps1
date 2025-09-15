# PowerShell script to clean up all terratest VPCs across all regions

$regions = @("us-east-1", "us-west-1", "us-west-2", "us-east-2")

foreach ($region in $regions) {
    Write-Host "Processing region: $region"
    
    # Get all terratest VPCs in this region
    $vpcs = aws ec2 describe-vpcs --region $region --filters "Name=tag:ManagedBy,Values=terratest" --query 'Vpcs[*].VpcId' --output text
    
    if ($vpcs) {
        Write-Host "Found VPCs in $region : $vpcs"
        
        $vpcArray = $vpcs -split '\s+' | Where-Object { $_.Trim() -ne "" }
        foreach ($vpc in $vpcArray) {
            if ($vpc.Trim()) {
                Write-Host "Cleaning up VPC: $vpc in region: $region"
                
                # Get subnets for this VPC
                $subnets = aws ec2 describe-subnets --region $region --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[*].SubnetId' --output text
                
                if ($subnets) {
                    Write-Host "  Found subnets: $subnets"
                    
                    # Delete subnets
                    $subnetArray = $subnets -split '\s+' | Where-Object { $_.Trim() -ne "" }
                    foreach ($subnet in $subnetArray) {
                        if ($subnet.Trim()) {
                            Write-Host "    Deleting subnet: $subnet"
                            aws ec2 delete-subnet --region $region --subnet-id $subnet
                        }
                    }
                }
                
                # Get internet gateways for this VPC
                $igws = aws ec2 describe-internet-gateways --region $region --filters "Name=attachment.vpc-id,Values=$vpc" --query 'InternetGateways[*].InternetGatewayId' --output text
                
                if ($igws) {
                    Write-Host "  Found internet gateways: $igws"
                    
                    # Detach and delete internet gateways
                    $igwArray = $igws -split '\s+' | Where-Object { $_.Trim() -ne "" }
                    foreach ($igw in $igwArray) {
                        if ($igw.Trim()) {
                            Write-Host "    Detaching internet gateway: $igw"
                            aws ec2 detach-internet-gateway --region $region --internet-gateway-id $igw --vpc-id $vpc
                            Write-Host "    Deleting internet gateway: $igw"
                            aws ec2 delete-internet-gateway --region $region --internet-gateway-id $igw
                        }
                    }
                }
                
                # Get route tables for this VPC (excluding main route table)
                $routeTables = aws ec2 describe-route-tables --region $region --filters "Name=vpc-id,Values=$vpc" --query 'RouteTables[?Associations[0].Main!=`true`].RouteTableId' --output text
                
                if ($routeTables) {
                    Write-Host "  Found route tables: $routeTables"
                    
                    # Delete route tables
                    $rtArray = $routeTables -split '\s+' | Where-Object { $_.Trim() -ne "" }
                    foreach ($rt in $rtArray) {
                        if ($rt.Trim()) {
                            Write-Host "    Deleting route table: $rt"
                            aws ec2 delete-route-table --region $region --route-table-id $rt
                        }
                    }
                }
                
                # Delete the VPC
                Write-Host "  Deleting VPC: $vpc"
                aws ec2 delete-vpc --region $region --vpc-id $vpc
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "  Successfully deleted VPC: $vpc"
                } else {
                    Write-Host "  Failed to delete VPC: $vpc"
                }
            }
        }
    } else {
        Write-Host "No terratest VPCs found in $region"
    }
    
    Write-Host ""
}

Write-Host "Cleanup completed!"
