# target:

# companies
#   comapany_name
#   status
#   projects
#     name
#     services
#       name
#       color
#     pavimentos
#       name
#       activities
#         service_name
#         duration

def get_companies_information
  companies = Company.all.map do |company|
    projects = company.projects.map do |project|
      services = Service.where(project: project).reduce([]) do |serviceList, service| 
        indexInServiceList = serviceList.find_index({ name: service.name })

        if indexInServiceList
          serviceList
        else
          serviceList.push({name: service.name, color: service.color })
        end
      end

      floors = project.floors.map do |floor| 
        activities = floor.activities.map do |activity| 
          {service_name: activity.service.name, duration: activity.work_duration} 
        end

        {
          name: floor.name,
          activities: activities
        }
      end

      {
        projectName: project.name,
        services: services,
        floors: floors,
        createdAt: project.created_at
      }
    end

    {
      companyName: company.name,
      status: company.subscription_plan.status,
      projects: projects
    }
  end
end

get_companies_information.to_json