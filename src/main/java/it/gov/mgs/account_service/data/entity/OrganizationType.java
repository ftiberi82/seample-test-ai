package it.gov.mgs.account_service.data.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * Rappresenta una tipologia (livello) organizzativa (tabella ORGANIZATION_TYPE).
 * Ogni record definisce un livello gerarchico utilizzato per classificare le
 * organizzazioni (es. Ministero, Direzione, Ufficio ...).
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ORGANIZATION_TYPE")
public class OrganizationType extends AuditedEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", nullable = false, columnDefinition = "uniqueidentifier")
    private UUID id;

    @Column(name = "order", nullable = false, unique = true)
    private Integer order;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", length = 1024)
    private String description;

}
