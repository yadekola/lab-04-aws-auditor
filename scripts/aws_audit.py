import boto3
import csv
import json
from datetime import datetime

audit_records = []

audit_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

print("Audit Time:", audit_time)

instance_prices = {
    "t3.micro": 0.0104,
    "t3.small": 0.0208,
    "t3.medium": 0.0416
}

ec2 = boto3.client("ec2", region_name="us-east-1")

# response = ec2.describe_instances(
#     Filters=[
#         {
#             "Name": "instance-state-name",
#             "Values": ["running", "stopped"]
#         }
#     ]
# )

paginator = ec2.get_paginator("describe_instances")

pages = paginator.paginate(
    Filters=[
        {
            "Name": "instance-state-name",
            "Values": ["running", "stopped"]
        }
    ]
)

print("AWS connection successful!")


for page in pages:
    for reservation in page["Reservations"]:
        for instance in reservation["Instances"]:

            name = None
            owner = None

            for tag in instance.get("Tags", []):
                if tag["Key"] == "Name":
                    name = tag["Value"]

                elif tag["Key"] == "Owner":
                    owner = tag["Value"]

            print("Instance ID:", instance["InstanceId"])
            print("Instance Type:", instance["InstanceType"])

            instance_data = {
                "Instance ID": instance["InstanceId"],
                "Instance Type": instance["InstanceType"],
                "State": instance["State"]["Name"],
                "Name": name,
                "Owner": owner,
                "Audit Time": audit_time,
                "Launch Time": instance["LaunchTime"].strftime("%Y-%m-%d %H:%M:%S"),
            }

            hourly_price = instance_prices.get(
                instance["InstanceType"]
            )

            if instance["State"]["Name"] == "stopped":
                instance_data["Estimated Monthly Cost"] = 0.00

            elif hourly_price is None:
                instance_data["Estimated Monthly Cost"] = None
                print("WARNING: Price not available for this instance type.")

            else:
                monthly_cost = hourly_price * 730
                instance_data["Estimated Monthly Cost"] = round(
                    monthly_cost, 2
                )
                print("Estimated Monthly Cost: $", round(monthly_cost, 2))

            # Save each instance's information
            audit_records.append(instance_data)

            print("State:", instance["State"]["Name"])
            print("Name:", name)

            if not owner:
                print("WARNING: Owner tag is missing!")
            else:
                print("Owner:", owner)

            print("----------------------")


# Outside all three loops
if audit_records:

    total_instances = len(audit_records)
    missing_owners = 0
    missing_prices = 0
    running_instances = 0
    stopped_instances = 0
    total_monthly_cost = 0

    for record in audit_records:

        if not record["Owner"]:
            missing_owners += 1

        if record["Estimated Monthly Cost"] is None:
            missing_prices += 1
        else:
            total_monthly_cost += record["Estimated Monthly Cost"]

        if record["State"] == "running":
            running_instances += 1
        elif record["State"] == "stopped":
            stopped_instances += 1

    print("\n===== EC2 AUDIT SUMMARY =====")
    print("Total Instances:", total_instances)
    print("Missing Owner Tags:", missing_owners)
    print("Missing Prices:", missing_prices)
    print("Running Instances:", running_instances)
    print("Stopped Instances:", stopped_instances)
    print("Total Estimated Monthly Cost: $", round(total_monthly_cost, 2))

    # Export CSV
    with open("ec2_audit_report.csv", "w", newline="", encoding="utf-8") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=audit_records[0].keys()
        )

        writer.writeheader()
        writer.writerows(audit_records)

    print("Audit report saved successfully!")

    # Export JSON
    with open("ec2_audit_report.json", "w", encoding="utf-8") as file:

        json.dump(audit_records, file, indent=4)

    print("JSON audit report saved successfully!")

else:
    print("No EC2 instances found.")

# Save each instances information
# if audit_records:
#     print("Preparing audit report...")
# else:
#     print("No EC2 instances found.")

#     print("----------------------")